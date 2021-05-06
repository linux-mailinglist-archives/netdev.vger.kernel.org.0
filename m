Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 170CE374C92
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 03:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbhEFBES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 21:04:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:53222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229465AbhEFBEQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 21:04:16 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7911A610EA;
        Thu,  6 May 2021 01:03:18 +0000 (UTC)
Date:   Wed, 5 May 2021 21:03:16 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Joel Fernandes <joelaf@google.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [RFC][PATCH] vhost/vsock: Add vsock_list file to map cid with
 vhost tasks
Message-ID: <20210505210316.11e1bbcd@oasis.local.home>
In-Reply-To: <20210505163855.32dad8e7@gandalf.local.home>
References: <20210505163855.32dad8e7@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/7JbDmOvvGcBoZTDb=tjglhB"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--MP_/7JbDmOvvGcBoZTDb=tjglhB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

For kicks, I wrote this program that uses libtracefs to search all CIDS
(1-255), and find the kvm guests that are attached to them.

It traces the sched_wakeup and kvm_exit, looking for:

 this_task -> wakeup -> wakeup -> kvm_exit

when doing a connect to a cid.

When it finds the pid that did a kvm_exit, it knows that's the PID that
is woken by the vhost worker task. It's a little slow, and I would
really like a better way to do this, but it's at least an option that
is available now.

-- Steve

--MP_/7JbDmOvvGcBoZTDb=tjglhB
Content-Type: text/x-c++src
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=vsock-list.c

#define _GNU_SOURCE
#include <asm/types.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <linux/vm_sockets.h>

#include <tracefs.h>

#define MAX_CID		256

static int this_pid;

static int open_vsock(unsigned int cid, unsigned int port)
{
	struct sockaddr_vm addr = {
		.svm_family = AF_VSOCK,
		.svm_cid = cid,
		.svm_port = port,
	};
	int sd;

	sd = socket(AF_VSOCK, SOCK_STREAM, 0);
	if (sd < 0)
		return -1;

	if (connect(sd, (struct sockaddr *)&addr, sizeof(addr)))
		return -1;

	return sd;
}

struct pids {
	struct pids		*next;
	int			pid;
};

struct trace_info {
	struct tracefs_instance		*instance;
	struct tep_handle		*tep;
	struct tep_event		*wake_up;
	struct tep_event		*kvm_exit;
	struct tep_format_field		*common_pid;
	struct tep_format_field		*wake_pid;
	struct pids			*pids;
	int				cid;
	int				pid;
};

static void tear_down_trace(struct trace_info *info)
{
	tracefs_instance_file_write(info->instance, "events/enable", "0");
	tracefs_instance_destroy(info->instance);
	tracefs_instance_free(info->instance);
	tep_free(info->tep);
}

static int setup_trace(struct trace_info *info)
{
	const char *systems[] = { "sched", "kvm", NULL};
	char *name;
	int ret;

	info->pids = NULL;

	ret = asprintf(&name, "vsock_find-%d\n", getpid());
	if (ret < 0)
		return ret;

	info->instance = tracefs_instance_create(name);
	free(name);
	if (!info->instance)
		return -1;

	tracefs_trace_off(info->instance);
	info->tep = tracefs_local_events_system(NULL, systems);
	if (!info->tep)
		goto fail;

	info->wake_up = tep_find_event_by_name(info->tep, "sched", "sched_waking");
	if (!info->wake_up) {
		fprintf(stderr, "Failed to find sched_waking\n");
		goto fail;
	}

	info->kvm_exit = tep_find_event_by_name(info->tep, "kvm", "kvm_exit");
	if (!info->kvm_exit) {
		fprintf(stderr, "Failed to find kvm_exit\n");
		goto fail;
	}

	info->wake_pid = tep_find_any_field(info->wake_up, "pid");
	if (!info->wake_pid) {
		fprintf(stderr, "Failed to find wake up pid\n");
		goto fail;
	}

	info->common_pid = tep_find_common_field(info->wake_up,
						 "common_pid");
	if (!info->common_pid) {
		fprintf(stderr, "Failed to find common pid\n");
		goto fail;
	}

	ret = tracefs_instance_file_write(info->instance, "events/sched/sched_waking/enable", "1");
	if (ret < 0) {
		fprintf(stderr, "Failed to enable sched_waking\n");
		goto fail;
	}

	ret = tracefs_instance_file_write(info->instance, "events/kvm/kvm_exit/enable", "1");
	if (ret < 0) {
		fprintf(stderr, "Failed to enable kvm_exit\n");
		goto fail;
	}

	return 0;
fail:
	tear_down_trace(info);
	return -1;
}


static void free_pids(struct pids *pids)
{
	struct pids *next;

	while (pids) {
		next = pids;
		pids = pids->next;
		free(next);
	}
}

static void add_pid(struct pids **pids, int pid)
{
	struct pids *new_pid;

	new_pid = malloc(sizeof(*new_pid));
	if (!new_pid)
		return;

	new_pid->pid = pid;
	new_pid->next = *pids;
	*pids = new_pid;
}

static bool match_pid(struct pids *pids, int pid)
{
	while (pids) {
		if (pids->pid == pid)
			return true;
		pids = pids->next;
	}
	return false;
}

static int callback(struct tep_event *event, struct tep_record *record,
		    int cpu, void *data)
{
	struct trace_info *info = data;
	struct tep_handle *tep = info->tep;
	unsigned long long val;
	int type;
	int pid;
	int ret;

	ret = tep_read_number_field(info->common_pid, record->data, &val);
	if (ret < 0)
		return 0;

	pid = val;

	if (!match_pid(info->pids, pid))
		return 0;

	type = tep_data_type(tep, record);
	if (type == info->kvm_exit->id) {
		info->pid = pid;
		return -1;
	}

	if (type != info->wake_up->id)
		return 0;

	ret = tep_read_number_field(info->wake_pid, record->data, &val);
	if (ret < 0)
		return 0;

	add_pid(&info->pids, (int)val);
	return 0;
}

static void print_cid_pid(int cid, int pid)
{
	FILE *fp;
	char *path;
	char *buf = NULL;
	char *save;
	size_t l = 0;
	int tgid = -1;

	if (asprintf(&path, "/proc/%d/status", pid) < 0)
		return;

	fp = fopen(path, "r");
	free(path);
	if (!fp)
		return;

	while (getline(&buf, &l, fp) > 0) {
		char *tok;

		if (strncmp(buf, "Tgid:", 5) != 0)
			continue;
		tok = strtok_r(buf, ":", &save);
		if (!tok)
			continue;
		tok = strtok_r(NULL, ":", &save);
		if (!tok)
			continue;
		while (isspace(*tok))
			tok++;
		tgid = strtol(tok, NULL, 0);
		break;
	}
	free(buf);

	if (tgid >= 0)
		printf("%d\t%d\n", cid, tgid);
}

static void find_cid(struct trace_info *info, int cid)
{
	int fd;

	add_pid(&info->pids, this_pid);

	tracefs_instance_file_clear(info->instance, "trace");
	tracefs_trace_on(info->instance);
	fd = open_vsock(cid, -1);
	tracefs_trace_off(info->instance);
	if (fd >= 0)
		close(fd);
	info->cid = cid;
	info->pid = -1;
	tracefs_iterate_raw_events(info->tep, info->instance,
				   NULL, 0, callback, info);
	if (info->pid >= 0)
		print_cid_pid(cid, info->pid);
	tracefs_trace_off(info->instance);
	free_pids(info->pids);
	info->pids = NULL;
}

static int find_cids(void)
{
	struct trace_info info ;
	int cid;

	if (setup_trace(&info) < 0)
		return -1;

	for (cid = 0; cid < MAX_CID; cid++)
		find_cid(&info, cid);

	tear_down_trace(&info);
	return 0;
}

int main(int argc, char *argv[])
{
	this_pid = getpid();
	find_cids();
	exit(0);
}

--MP_/7JbDmOvvGcBoZTDb=tjglhB--
