Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3CB8214EF2
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 21:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbgGETmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 15:42:36 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:25508 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727902AbgGETmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 15:42:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593978155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=Nre+vcTZuioR9qndvPPDHYxrgwQ/M91HckbWLUZ5+GI=;
        b=GEhJ6DMgET96C3B5LDrSaFxlRGouJP2lWaD+lNXEm6k4UADU+/7IKA/86f232D+6ejcNvW
        1Z1DiVE6boUnQrBM1zJURodjhzFU1Skx0WtB0rGTEH5R1pi7N5DLC4Rjj70kLgjOwVKtRD
        IZQNbMq1Q6Clya4BsbepTO6Fov0uHQA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-C0tMnLRYPvyuwOP0ZQNRZA-1; Sun, 05 Jul 2020 15:42:33 -0400
X-MC-Unique: C0tMnLRYPvyuwOP0ZQNRZA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6BC321005510;
        Sun,  5 Jul 2020 19:42:31 +0000 (UTC)
Received: from krava (unknown [10.40.192.42])
        by smtp.corp.redhat.com (Postfix) with SMTP id D40AB7BD7F;
        Sun,  5 Jul 2020 19:42:25 +0000 (UTC)
Date:   Sun, 5 Jul 2020 21:42:25 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     linux-s390@vger.kernel.org,
        Sumanth Korikkar <Sumanth.Korikkar@ibm.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Yauheni Kaliuta <yauheni.kaliuta@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Brendan Gregg <brendan.d.gregg@gmail.com>, bas@baslab.org,
        Matheus Marchini <mat@mmarchini.me>, Daniel Xu <dxu@dxuuu.xyz>
Subject: bpf: bpf_probe_read helper restriction on s390x
Message-ID: <20200705194225.GB3356590@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi,
with following commit:
  0ebeea8ca8a4 bpf: Restrict bpf_probe_read{, str}() only to archs where they work

the bpf_probe_read BPF helper is restricted on architectures that
have 'non overlapping address space' and select following config:

   select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE

there's also nice explanation in this commit's changelog:
  6ae08ae3dea2 bpf: Add probe_read_{user, kernel} and probe_read_{user, kernel}_str helpers


We have a problem with bpftrace not working properly on s390x because
bpf_probe_read is no longer available, and bpftrace does not use
bpf_probe_read_(user/kernel) variants yet.

My question is if s390x is 'arch with overlapping address space' and we
could fix this by adding ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE for s390x
or we need to fix bpftrace to detect this, which we probably need to do
in any case ;-)

thanks,
jirka

