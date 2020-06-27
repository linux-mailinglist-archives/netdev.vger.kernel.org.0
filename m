Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F30120C174
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 15:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgF0NWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 09:22:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40790 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726553AbgF0NV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 09:21:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593264113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=hKht7bfBBCDPvliH+ugHeghHVWGWFDdH8mAPJynBmG4=;
        b=Lp/xvBxyri6COKTBHu9EonLCyMhnqgxgyDlZX8W8EAqchwZnBHAuf1FOnFBuZIVMdw8iw3
        TJZ4swOAW6DvdoeBit0gxcwsMg1N+wP1L3OB+MEiI1XFc3IrXOYQP+oJT2n+i6lLuIZDET
        aUt1zVqY14j+r2MQ8rStGDjgwRBBwok=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-190-e7dHLOALNiOjIUMgXmztUg-1; Sat, 27 Jun 2020 09:21:47 -0400
X-MC-Unique: e7dHLOALNiOjIUMgXmztUg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D29E91005512;
        Sat, 27 Jun 2020 13:21:44 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5E22D71662;
        Sat, 27 Jun 2020 13:21:31 +0000 (UTC)
From:   Richard Guy Briggs <rgb@redhat.com>
To:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc:     Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com,
        omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com,
        eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com,
        nhorman@tuxdriver.com, dwalsh@redhat.com, mpatel@redhat.com,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH ghak90 V9 00/13] audit: implement container identifier
Date:   Sat, 27 Jun 2020 09:20:33 -0400
Message-Id: <cover.1593198710.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement kernel audit container identifier.

This patchset is an eighth based on the proposal document (V4) posted:
	https://www.redhat.com/archives/linux-audit/2019-September/msg00052.html

The first patch was the last patch from ghak81 that was absorbed into
this patchset since its primary justification is the rest of this
patchset.

The second patch implements the proc fs write to set the audit container
identifier of a process, emitting an AUDIT_CONTAINER_OP record to
announce the registration of that audit container identifier on that
process.  This patch requires userspace support for record acceptance
and proper type display.  This patch now includes the conversion 
over from a simple u64 to a list member that includes owner information
to check for descendancy, allow process injection into a container and
prevent id reuse by other orchestrators.

The third implements reading the audit container identifier from the
proc filesystem for debugging.  This patch wasn't planned for upstream
inclusion but is starting to become more likely.

The fourth logs the drop of an audit container identifier once all tasks
using that audit container identifier have exited.

The 5th implements the auxiliary record AUDIT_CONTAINER_ID if an audit
container identifier is associated with an event.  This patch requires
userspace support for proper type display.

The 6th adds audit daemon signalling provenance through audit_sig_info2.

The 7th creates a local audit context to be able to bind a standalone
record with a locally created auxiliary record.

The 8th patch adds audit container identifier records to the user
standalone records.

The 9th adds audit container identifier filtering to the exit,
exclude and user lists.  This patch adds the AUDIT_CONTID field and
requires auditctl userspace support for the --contid option.

The 10th adds network namespace audit container identifier labelling
based on member tasks' audit container identifier labels which supports
standalone netfilter records that don't have a task context and lists
each container to which that net namespace belongs.

The 11th checks that the target is a descendant for nesting and
refactors to avoid a duplicate of the copied function.

The 12th adds tracking and reporting for container nesting.  
This enables kernel filtering and userspace searches of nested audit
container identifiers.

The 13th adds a mechanism to allow a process to be designated as a
container orchestrator/engine in non-init user namespaces.


Example: Set an audit container identifier of 123456 to the "sleep" task:

  sleep 2&
  child=$!
  echo 123456 > /proc/$child/audit_containerid; echo $?
  ausearch -ts recent -m container_op
  echo child:$child contid:$( cat /proc/$child/audit_containerid)

This should produce a record such as:

  type=CONTAINER_OP msg=audit(2018-06-06 12:39:29.636:26949) : op=set opid=2209 contid=123456 old-contid=18446744073709551615


Example: Set a filter on an audit container identifier 123459 on /tmp/tmpcontainerid:

  contid=123459
  key=tmpcontainerid
  auditctl -a exit,always -F dir=/tmp -F perm=wa -F contid=$contid -F key=$key
  perl -e "sleep 1; open(my \$tmpfile, '>', \"/tmp/$key\"); close(\$tmpfile);" &
  child=$!
  echo $contid > /proc/$child/audit_containerid
  sleep 2
  ausearch -i -ts recent -k $key
  auditctl -d exit,always -F dir=/tmp -F perm=wa -F contid=$contid -F key=$key
  rm -f /tmp/$key

This should produce an event such as:

  type=CONTAINER_ID msg=audit(2018-06-06 12:46:31.707:26953) : contid=123459
  type=PROCTITLE msg=audit(2018-06-06 12:46:31.707:26953) : proctitle=perl -e sleep 1; open(my $tmpfile, '>', "/tmp/tmpcontainerid"); close($tmpfile);
  type=PATH msg=audit(2018-06-06 12:46:31.707:26953) : item=1 name=/tmp/tmpcontainerid inode=25656 dev=00:26 mode=file,644 ouid=root ogid=root rdev=00:00 obj=unconfined_u:object_r:user_tmp_t:s0 nametype=CREATE cap_fp=none cap_fi=none cap_fe=0 cap_fver=0
  type=PATH msg=audit(2018-06-06 12:46:31.707:26953) : item=0 name=/tmp/ inode=8985 dev=00:26 mode=dir,sticky,777 ouid=root ogid=root rdev=00:00 obj=system_u:object_r:tmp_t:s0 nametype=PARENT cap_fp=none cap_fi=none cap_fe=0 cap_fver=0
  type=CWD msg=audit(2018-06-06 12:46:31.707:26953) : cwd=/root
  type=SYSCALL msg=audit(2018-06-06 12:46:31.707:26953) : arch=x86_64 syscall=openat success=yes exit=3 a0=0xffffffffffffff9c a1=0x5621f2b81900 a2=O_WRONLY|O_CREAT|O_TRUNC a3=0x1b6 items=2 ppid=628 pid=2232 auid=root uid=root gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root tty=ttyS0 ses=1 comm=perl exe=/usr/bin/perl subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=tmpcontainerid

Example: Test multiple containers on one netns:

  sleep 5 &
  child1=$!
  containerid1=123451
  echo $containerid1 > /proc/$child1/audit_containerid
  sleep 5 &
  child2=$!
  containerid2=123452
  echo $containerid2 > /proc/$child2/audit_containerid
  iptables -I INPUT -i lo -p icmp --icmp-type echo-request -j AUDIT --type accept
  iptables -I INPUT  -t mangle -i lo -p icmp --icmp-type echo-request -j MARK --set-mark 0x12345555
  sleep 1;
  bash -c "ping -q -c 1 127.0.0.1 >/dev/null 2>&1"
  sleep 1;
  ausearch -i -m NETFILTER_PKT -ts boot|grep mark=0x12345555
  ausearch -i -m NETFILTER_PKT -ts boot|grep contid=|grep $containerid1|grep $containerid2

This would produce an event such as:

  type=NETFILTER_PKT msg=audit(03/15/2019 14:16:13.369:244) : mark=0x12345555 saddr=127.0.0.1 daddr=127.0.0.1 proto=icmp
  type=CONTAINER_ID msg=audit(03/15/2019 14:16:13.369:244) : contid=123452,123451


Includes the last patch of https://github.com/linux-audit/audit-kernel/issues/81
Please see the github audit kernel issue for the main feature:
  https://github.com/linux-audit/audit-kernel/issues/90
and the kernel filter code:
  https://github.com/linux-audit/audit-kernel/issues/91
and the network support:
  https://github.com/linux-audit/audit-kernel/issues/92
Please see the github audit userspace issue for supporting record types:
  https://github.com/linux-audit/audit-userspace/issues/51
and filter code:
  https://github.com/linux-audit/audit-userspace/issues/40
Please see the github audit testsuiite issue for the test case:
  https://github.com/linux-audit/audit-testsuite/issues/64
  https://github.com/rgbriggs/audit-testsuite/tree/ghat64-contid
  https://githu.com/linux-audit/audit-testsuite/pull/91
Please see the github audit wiki for the feature overview:
  https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID

The code is also posted at:
  git://toccata2.tricolour.ca/linux-2.6-rgb.git ghak90-audit-containerID.v9

Changelog:
v9
- rebase on v5.8-rc1
- fix whitespace and oversize lines where practicable
- remove harmless duplicate S_IRUSR in capcontid
- return -EBUSY for both threading and children (drop -EALREADY)
- return -EEXIST if already set and not nesting (drop -ECHILD)
- fix unbalanced brace and remove elseif ladder
- drop check for same contid set again as redundant (drop -EADDRINUSE)
- get reference to contobj's parent taskstruct
- protect all contid list updates with audit_contobj_list_lock
- protect refcounts with rcu read lock
- convert _audit_contobj to _audit_contobj_get, which calls _audit_contobj_hold
- convert audit_log_container_id() and audit_log_contid() from u64 to contobj, simplifying
- issue death certificate on contid after exit of last task
- keep contobj ref to block reuse with -ESHUTDOWN until auditd exit or signal info
- report all contids nested
- rework sig_info2 format to accomodate contid list
- fix zero-length array in include/linux/audit.h struct audit_sig_info2 data[]
- found bug in audit_alloc_local, don't check audit_ever_enabled, since all callers check audit_enabled
- remove warning at declaration of audit_sig_cid of reuse since reuse is now blocked
- report descendancy checking errcodes under -EXDEV (drop -EBADSLT)
- add missed check, replace audit_contid_isowner with audit_contid_isnesting
- limit calls to audit_log_format() with if(iter->parent) ...
- list only one contid in contid, nested in old-contid to avoid duplication
- switch to comma delimiter, carrat modifier in nested contid list
- special case -1 for AUDIT_CID_UNSET printing
- drop contid depth limit and netns contid limit patches
- enforce capcontid policy on contid write and read
- squash conversion to contobj into contid intro patch

v8
- rebase on v5.5-rc1 audit/next
- remove subject attrs in CONTAINER_OP record
- group audit_contid_list_lock with audit_contid_hash
- in audit_{set,log}_contid(), break out of loop after finding target
- use target var to size kmalloc
- rework audit_cont_owner() to bool audit_contid_isowner() and move to where used
- create static void audit_cont_hold(struct audit_contobj *cont) { refcount_inc(&cont->refcount); }
- rename audit_cont{,_*} refs to audit_contobj{,_*}
- prefix special local functions with _ [audit_contobj*()]
- protect contid list traversals with rcu_read_lock() and updates with audit_contid_list_lock
- protect real_parent in audit_contid_depth() with rcu_dereference
- give new contid field nesting format in patch description
- squash task_is_descendant()
- squash support for NETFILTER_PKT into network namespaces
- limit nesting depth based on record length overflow, bandwidth and storage
- implent control for audit container identifier nesting depth limit
- make room for audit_bpf patches (bump CONTAINER_ID to 1335)
- squash proc interface into capcontid
- remove netlink access to loginuid/sessionid/contid/capcontid
- delete 32k contid limit patch
- document potential overlap between signal delivery and contid reuse
- document audit_contobj_list_lock coverage
- document disappearing orch task injection limitation
- limit the number of containers that can be associated with a network namespace
- implent control for audit container identifier netns count limit 

v7
- remove BUG() in audit_comparator64()
- rebase on v5.2-rc1 audit/next
- resolve merge conflict with ghak111 (signal_info regardless syscall)
- resolve merge conflict with ghak73 (audit_field_valid)
- resolve merge conflict with ghak64 (saddr_fam filter)
- resolve merge conflict with ghak10 (ntp audit) change AUDIT_CONTAINER_ID from 1332 to 1334
- rebase on v5.3-rc1 audit/next
- track container owner
- only permit setting contid of descendants for nesting
- track drop of contid and permit reuse
- track and report container nesting
- permit filtering on any nested contid
- set/get contid and loginuid/sessionid via netlink
- implement capcontid to enable orchestrators in non-init user
  namespaces
- limit number of containers
- limit depth of container nesting

v6
- change TMPBUFLEN from 11 to 21 to cover the decimal value of contid
  u64 (nhorman)
- fix bug overwriting ctx in struct audit_sig_info, move cid above
  ctx[0] (nhorman)
- fix bug skipping remaining fields and not advancing bufp when copying
  out contid in audit_krule_to_data (omosnacec)
- add acks, tidy commit descriptions, other formatting fixes (checkpatch
  wrong on audit_log_lost)
- cast ull for u64 prints
- target_cid tracking was moved from the ptrace/signal patch to
  container_op
- target ptrace and signal records were moved from the ptrace/signal
  patch to container_id
- auditd signaller tracking was moved to a new AUDIT_SIGNAL_INFO2
  request and record
- ditch unnecessary list_empty() checks
- check for null net and aunet in audit_netns_contid_add()
- swap CONTAINER_OP contid/old-contid order to ease parsing

v5
- address loginuid and sessionid syscall scope in ghak104
- address audit_context in CONFIG_AUDIT vs CONFIG_AUDITSYSCALL in ghak105
- remove tty patch, addressed in ghak106
- rebase on audit/next v5.0-rc1
  w/ghak59/ghak104/ghak103/ghak100/ghak107/ghak105/ghak106/ghak105sup
- update CONTAINER_ID to CONTAINER_OP in patch description
- move audit_context in audit_task_info to CONFIG_AUDITSYSCALL
- move audit_alloc() and audit_free() out of CONFIG_AUDITSYSCALL and into
  CONFIG_AUDIT and create audit_{alloc,free}_syscall
- use plain kmem_cache_alloc() rather than kmem_cache_zalloc() in audit_alloc()
- fix audit_get_contid() declaration type error
- move audit_set_contid() from auditsc.c to audit.c
- audit_log_contid() returns void
- audit_log_contid() handed contid rather than tsk
- switch from AUDIT_CONTAINER to AUDIT_CONTAINER_ID for aux record
- move audit_log_contid(tsk/contid) & audit_contid_set(tsk)/audit_contid_valid(contid)
- switch from tsk to current
- audit_alloc_local() calls audit_log_lost() on failure to allocate a context
- add AUDIT_USER* non-syscall contid record
- cosmetic cleanup double parens, goto out on err
- ditch audit_get_ns_contid_list_lock(), fix aunet lock race
- switch from all-cpu read spinlock to rcu, keep spinlock for write
- update audit_alloc_local() to use ktime_get_coarse_real_ts64()
- add nft_log support
- add call from do_exit() in audit_free() to remove contid from netns
- relegate AUDIT_CONTAINER ref= field (was op=) to debug patch

v4
- preface set with ghak81:"collect audit task parameters"
- add shallyn and sgrubb acks
- rename feature bitmap macro
- rename cid_valid() to audit_contid_valid()
- rename AUDIT_CONTAINER_ID to AUDIT_CONTAINER_OP
- delete audit_get_contid_list() from headers
- move work into inner if, delete "found"
- change netns contid list function names
- move exports for audit_log_contid audit_alloc_local audit_free_context to non-syscall patch
- list contids CSV
- pass in gfp flags to audit_alloc_local() (fix audit_alloc_context callers)
- use "local" in lieu of abusing in_syscall for auditsc_get_stamp()
- read_lock(&tasklist_lock) around children and thread check
- task_lock(tsk) should be taken before first check of tsk->audit
- add spin lock to contid list in aunet
- restrict /proc read to CAP_AUDIT_CONTROL
- remove set again prohibition and inherited flag
- delete contidion spelling fix from patchset, send to netdev/linux-wireless

v3
- switched from containerid in task_struct to audit_task_info (depends on ghak81)
- drop INVALID_CID in favour of only AUDIT_CID_UNSET
- check for !audit_task_info, throw -ENOPROTOOPT on set
- changed -EPERM to -EEXIST for parent check
- return AUDIT_CID_UNSET if !audit_enabled
- squash child/thread check patch into AUDIT_CONTAINER_ID patch
- changed -EPERM to -EBUSY for child check
- separate child and thread checks, use -EALREADY for latter
- move addition of op= from ptrace/signal patch to AUDIT_CONTAINER patch
- fix && to || bashism in ptrace/signal patch
- uninline and export function for audit_free_context()
- drop CONFIG_CHANGE, FEATURE_CHANGE, ANOM_ABEND, ANOM_SECCOMP patches
- move audit_enabled check (xt_AUDIT)
- switched from containerid list in struct net to net_generic's struct audit_net
- move containerid list iteration into audit (xt_AUDIT)
- create function to move namespace switch into audit
- switched /proc/PID/ entry from containerid to audit_containerid
- call kzalloc with GFP_ATOMIC on in_atomic() in audit_alloc_context()
- call kzalloc with GFP_ATOMIC on in_atomic() in audit_log_container_info()
- use xt_net(par) instead of sock_net(skb->sk) to get net
- switched record and field names: initial CONTAINER_ID, aux CONTAINER, field CONTID
- allow to set own contid
- open code audit_set_containerid
- add contid inherited flag
- ccontainerid and pcontainerid eliminated due to inherited flag
- change name of container list funcitons
- rename containerid to contid
- convert initial container record to syscall aux
- fix spelling mistake of contidion in net/rfkill/core.c to avoid contid name collision

v2
- add check for children and threads
- add network namespace container identifier list
- add NETFILTER_PKT audit container identifier logging
- patch description and documentation clean-up and example
- reap unused ppid

Richard Guy Briggs (13):
  audit: collect audit task parameters
  audit: add container id
  audit: read container ID of a process
  audit: log drop of contid on exit of last task
  audit: log container info of syscalls
  audit: add contid support for signalling the audit daemon
  audit: add support for non-syscall auxiliary records
  audit: add containerid support for user records
  audit: add containerid filtering
  audit: add support for containerid to network namespaces
  audit: contid check descendancy and nesting
  audit: track container nesting
  audit: add capcontid to set contid outside init_user_ns

 fs/proc/base.c              | 112 +++++++-
 include/linux/audit.h       | 135 +++++++++-
 include/linux/sched.h       |  10 +-
 include/uapi/linux/audit.h  |  10 +-
 init/init_task.c            |   3 +-
 init/main.c                 |   2 +
 kernel/audit.c              | 621 +++++++++++++++++++++++++++++++++++++++++++-
 kernel/audit.h              |  23 ++
 kernel/auditfilter.c        |  61 +++++
 kernel/auditsc.c            | 110 ++++++--
 kernel/fork.c               |   1 -
 kernel/nsproxy.c            |   4 +
 kernel/sched/core.c         |  33 +++
 net/netfilter/nft_log.c     |  11 +-
 net/netfilter/xt_AUDIT.c    |  11 +-
 security/selinux/nlmsgtab.c |   1 +
 security/yama/yama_lsm.c    |  33 ---
 17 files changed, 1085 insertions(+), 96 deletions(-)

-- 
1.8.3.1

