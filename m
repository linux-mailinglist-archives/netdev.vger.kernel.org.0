Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C36FA165EB3
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 14:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbgBTN06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 08:26:58 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:59300 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726959AbgBTN05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 08:26:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582205216;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ngeVrB3Tm8+XJ5G0I1wQIONd8/FUCOa1t00KU8I/VRI=;
        b=A1lE7MPhncxRT0Vn2GFo5fO0CbCixPqiTn0mqiOD7OsNNBe99xujWwCoq1JmkPv50z+PaP
        evtMoss+rd40e/c9oQJ/R0yoPf5TKBz/CECgIPIPHqpCyHhf6yQowe01MTPjc8Cpepvsyb
        +zwMpGCYWYYzjfvHsTDKMXm3q2N3y/k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294-fxTgFi99N4OvluUDg_PU0A-1; Thu, 20 Feb 2020 08:26:54 -0500
X-MC-Unique: fxTgFi99N4OvluUDg_PU0A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E38AB107ACC5;
        Thu, 20 Feb 2020 13:26:52 +0000 (UTC)
Received: from localhost.localdomain (wsfd-netdev76.ntdv.lab.eng.bos.redhat.com [10.19.188.157])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 247BC863A5;
        Thu, 20 Feb 2020 13:26:49 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     bpf@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, toke@redhat.com
Subject: [PATCH bpf-next v5 0/3] libbpf: Add support for dynamic program attach target
Date:   Thu, 20 Feb 2020 13:26:13 +0000
Message-Id: <158220517358.127661.1514720920408191215.stgit@xdp-tutorial>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

v1 -> v2: Remove requirement for attach type hint in API
v2 -> v3: Moved common warning to __find_vmlinux_btf_id, requested by And=
rii
          Updated the xdp_bpf2bpf test to use this new API
v3 -> v4: Split up patch, update libbpf.map version
v4 -> v5: Fix return code, and prog assignment in test case

