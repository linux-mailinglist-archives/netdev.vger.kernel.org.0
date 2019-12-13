Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A188411E6AD
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 16:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbfLMPgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 10:36:13 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25933 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727992AbfLMPgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 10:36:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576251371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=XdvQKU8LiqO/th1XH/f5TTkHcNsE/YPklKDD6xZt6qQ=;
        b=Db27FA3+Q1kolvE9edN0LO/0RSX8ErXy0AXWemMr3jEbp2sKgIfCuY92NDItgl+efEwj4A
        XShBBAD1jHkRUKKbYHzvPbwxKTGo0fBy+RigcPZCLK/oA4kl9QMW8/NjXmFTRbnIuqN8cI
        E4HVdP8vJ0MfQU9aULmpF8oHf1oNxvo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-hbfm8CEePw28D6MRnwYrFA-1; Fri, 13 Dec 2019 10:36:07 -0500
X-MC-Unique: hbfm8CEePw28D6MRnwYrFA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 68935800582;
        Fri, 13 Dec 2019 15:36:05 +0000 (UTC)
Received: from krava (ovpn-205-9.brq.redhat.com [10.40.205.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 23A2C5C219;
        Fri, 13 Dec 2019 15:35:55 +0000 (UTC)
Date:   Fri, 13 Dec 2019 16:35:53 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [RFC] btf: Some structs are doubled because of struct ring_buffer
Message-ID: <20191213153553.GE20583@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,
the current BTF vmlinux file have some of the structs doubled:

  $ bpftool btf dump file /sys/kernel/btf/vmlinux | grep task_struct
  [150] STRUCT 'task_struct' size=11008 vlen=205
  [12262] STRUCT 'task_struct' size=11008 vlen=205

  $ bpftool btf dump file /sys/kernel/btf/vmlinux | grep "STRUCT 'perf_event'"
  [1666] STRUCT 'perf_event' size=1160 vlen=70
  [12301] STRUCT 'perf_event' size=1160 vlen=70

The reason seems to be that we have two distinct 'struct ring_buffer'
objects used in kernel: one in perf subsystem and one in kernel trace
subsystem.

When we compile kernel/trace/ring_buffer.c we have 'struct task_struct',
which references 'struct ring_buffer', which is at that compile time
defined in kernel/trace/ring_buffer.c.

While when we compile kernel/events/core.c we have 'struct task_struct',
which references ring buffer, which is at that compile time defined
in kernel/events/internal.h.

So we end up with 2 different 'struct task_struct' objects, and few
other objects which are on the way to the 'struct ring_buffer' field,
like:

	[1666] STRUCT 'perf_event' size=1160 vlen=70
		...
		'rb' type_id=2289 bits_offset=5632
		...

		[2289] PTR '(anon)' type_id=10872

			-> trace ring buffer

			[10872] STRUCT 'ring_buffer' size=184 vlen=12
				'flags' type_id=10 bits_offset=0
				'cpus' type_id=22 bits_offset=32
				'record_disabled' type_id=81 bits_offset=64
				...

	[12301] STRUCT 'perf_event' size=1160 vlen=70
		...
		'rb' type_id=13148 bits_offset=5632
		...

		[13148] PTR '(anon)' type_id=13147

			-> perf ring buffer

			[13147] STRUCT 'ring_buffer' size=240 vlen=33
				'refcount' type_id=795 bits_offset=0
				'callback_head' type_id=90 bits_offset=64
				'nr_pages' type_id=22 bits_offset=192
				'overwrite' type_id=22 bits_offset=224
				'paused' type_id=22 bits_offset=256
				...

I don't think dedup algorithm can handle this and I'm not sure if there's
some way in pahole to detect/prevent this.

I only found that if I rename the ring_buffer objects to have distinct
names, it will help:

  $ bpftool btf dump file /sys/kernel/btf/vmlinux | grep task_struct
  [150] STRUCT 'task_struct' size=11008 vlen=205

  $ bpftool btf dump file /sys/kernel/btf/vmlinux | grep "STRUCT 'perf_event'"
  [1665] STRUCT 'perf_event' size=1160 vlen=70

also the BTF data get smaller ;-) before:

  $ ll /sys/kernel/btf/vmlinux
  -r--r--r--. 1 root root 2067432 Dec 13 22:56 /sys/kernel/btf/vmlinux

after:
  $ ll /sys/kernel/btf/vmlinux
  -r--r--r--. 1 root root 1984345 Dec 13 23:02 /sys/kernel/btf/vmlinux


Peter, Steven,
if above is correct and there's no other better solution, would it be possible
to straighten up the namespace and user some distinct names for perf and ftrace
ring buffers?

thoughts?
jirka

