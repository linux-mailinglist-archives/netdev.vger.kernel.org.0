Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4C26161248
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 13:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbgBQMny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 07:43:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26649 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728468AbgBQMny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 07:43:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581943433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=NpQWEuB/IEwQsGwslWDiEa9TdUV+3uuR3ANn2KfIs1I=;
        b=WJuEe3yvYfyIuA+Gu93ayBOSQQVBV5w/hpiFgKNDfTm3PoVHPbyMdfKk712qWgsWMrtqYg
        j8hP7lAsgmiQXLDN27N/e12M0Cx2bUuz4xrVncVjNJKxQIo8vekZ0P9vz2WrI7BRHylyJN
        /XCAPyucYmmzkhApx+kTx7c3d2XKIYs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-89-se5-SG91PnSSgwHCQJFzjw-1; Mon, 17 Feb 2020 07:43:49 -0500
X-MC-Unique: se5-SG91PnSSgwHCQJFzjw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A84DCDB68;
        Mon, 17 Feb 2020 12:43:47 +0000 (UTC)
Received: from localhost.localdomain (wsfd-netdev76.ntdv.lab.eng.bos.redhat.com [10.19.188.157])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD65360BF1;
        Mon, 17 Feb 2020 12:43:43 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     bpf@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, toke@redhat.com
Subject: [PATCH bpf-next v4 0/3] libbpf: Add support for dynamic program attach target
Date:   Mon, 17 Feb 2020 12:42:52 +0000
Message-Id: <158194337246.104074.6407151818088717541.stgit@xdp-tutorial>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently when you want to attach a trace program to a bpf program
the section name needs to match the tracepoint/function semantics.

However the addition of the bpf_program__set_attach_target() API
allows you to specify the tracepoint/function dynamically.

The call flow would look something like this:

  xdp_fd =3D bpf_prog_get_fd_by_id(id);
  trace_obj =3D bpf_object__open_file("func.o", NULL);
  prog =3D bpf_object__find_program_by_title(trace_obj,
                                           "fentry/myfunc");
  bpf_program__set_expected_attach_type(prog, BPF_TRACE_FENTRY);
  bpf_program__set_attach_target(prog, xdp_fd,
                                 "xdpfilt_blk_all");
  bpf_object__load(trace_obj)

Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
cked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

v1 -> v2: Remove requirement for attach type hint in API
v2 -> v3: Moved common warning to __find_vmlinux_btf_id, requested by And=
rii
          Updated the xdp_bpf2bpf test to use this new API
v4 -> v4: Split up patch, update libbpf.map version

