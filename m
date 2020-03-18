Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18FC2189C87
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 14:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgCRNGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 09:06:37 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:56008 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726623AbgCRNGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 09:06:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584536796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=WuBZ3MfgqU4i3xCT80ZvXwaJs5bDpAGNY72tPGGaLDc=;
        b=YTl6J2biIpY06wp3RZf3z5eVOeX6JEwIjUwtW1EMSpHLt91HV4fbmYQ3xpC83NXBohp2ov
        bQztFxZk1xe/1a8TST7V85rbPrRMFlriYC+RObPvOoSthAZOUb4/upmXYYE/WYeXWxIvA8
        7YivavxuBF8x8+NBFVbbsrZ9V0e4c+I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-N9pzjCeUNnWrXTHmcrUOTQ-1; Wed, 18 Mar 2020 09:06:34 -0400
X-MC-Unique: N9pzjCeUNnWrXTHmcrUOTQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AB6F78C7265;
        Wed, 18 Mar 2020 13:06:06 +0000 (UTC)
Received: from localhost.localdomain (wsfd-netdev76.ntdv.lab.eng.bos.redhat.com [10.19.188.157])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 12D2C28D11;
        Wed, 18 Mar 2020 13:06:04 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     bpf@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com
Subject: [RFC PATCH bpf-next 0/3] bpf: add tracing for XDP programs using the BPF_PROG_TEST_RUN API
Date:   Wed, 18 Mar 2020 13:06:00 +0000
Message-Id: <158453675319.3043.5779623595270458781.stgit@xdp-tutorial>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I sent out this RFC to get an idea if the approach suggested here
would be something other people would also like to see. In addition,
this cover letter mentions some concerns and questions that need
answers before we can move to an acceptable implementation.

This patch adds support for tracing eBPF XDP programs that get
executed using the __BPF_PROG_RUN syscall. This is done by switching
from JIT (if enabled) to executing the program using the interpreter
and record each executed instruction.

For now, the execution history is printed to the kernel ring buffer
using pr_info(), the final version should have enough data stored in a
user-supplied buffer to reconstruct this output. This should probably
be part of bpftool, i.e. dump a similar output, and the ability to
store all this in an elf-like format for dumping/analyzing/replaying
at a later stage.

This patch does not dump the XDP packet content before and after
execution, however, this data is available to the caller of the API.

The __bpf_prog_run_trace() interpreter is a copy of __bpf_prog_run()
and we probably need a smarter way to re-use the code rather than a
blind copy with some changes.

Enabling the interpreter opens up the kernel for spectre variant 2,
guess that's why the BPF_JIT_ALWAYS_ON option was introduced (commit
290af86629b2). Enabling it for debugging in the field does not sound
like an option (talking to people doing kernel distributions).
Any idea how to work around this (lfence before any call this will
slow down, but I guess for debugging this does not matter)? I need to
research this more as I'm no expert in this area. But I think this
needs to be solved as I see this as a show stopper. So any input is
welcome.

To allow bpf_call support for tracing currently the general
interpreter is enabled. See the fixup_call_args() function for why
this is needed. We might need to find a way to fix this (see the above
section on spectre).

Signed-off-by: Eelco Chaudron <echaudro@redhat.com>

