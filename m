Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 839A335ABA
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 12:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbfFEK5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 06:57:06 -0400
Received: from hermes.domdv.de ([193.102.202.1]:4818 "EHLO hermes.domdv.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727231AbfFEK5G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 06:57:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=domdv.de;
         s=dk3; h=Content-Transfer-Encoding:MIME-Version:Content-Type:References:
        In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=g9z0TXmehP4FPwwFmO5FLEJXe/ruNzMFClnflml+DVg=; b=rGsTGowx4HeGdXPDTcQLDV/9vi
        prlEgDGGzWAnLvKXK+HZ1Rzn98ekX1MfKBiUs+yoaY2YUysRT6LXqCRGsH8d0mLqpco4ulHpjxsBi
        E92dYpmM40pOqec2/0AH66nOhfPDDYU7PgnE2uN8Bsah9pJWwEpSws55kYceBEfCdXsg=;
Received: from [fd06:8443:81a1:74b0::212] (port=1712 helo=castor.lan.domdv.de)
        by zeus.domdv.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.91)
        (envelope-from <ast@domdv.de>)
        id 1hYTbO-0002dQ-Kl; Wed, 05 Jun 2019 12:57:06 +0200
Received: from woody.lan.domdv.de ([10.1.9.28] helo=host028-server-9.lan.domdv.de)
        by castor.lan.domdv.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.91)
        (envelope-from <ast@domdv.de>)
        id 1hYTai-0007LQ-DG; Wed, 05 Jun 2019 12:56:24 +0200
Message-ID: <7b488768fb9ce1825597b510550ed6f8e9c88193.camel@domdv.de>
Subject: Re: [RFC][PATCH kernel_bpf] honor CAP_NET_ADMIN for BPF_PROG_LOAD
From:   Andreas Steinmetz <ast@domdv.de>
To:     Song Liu <liu.song.a23@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Date:   Wed, 05 Jun 2019 12:56:39 +0200
In-Reply-To: <CAPhsuW4TV5m_E3iO7FNyFoKwsKzGSZizbPfciHOJtun-=H_biA@mail.gmail.com>
References: <56c1f2f89428b49dad615fc13cc8c120d4ca4abf.camel@domdv.de>
         <CAPhsuW4TV5m_E3iO7FNyFoKwsKzGSZizbPfciHOJtun-=H_biA@mail.gmail.com>
Organization: D.O.M. Datenverarbeitung GmbH
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-05-28 at 14:04 -0700, Song Liu wrote:
> >          if (type != BPF_PROG_TYPE_SOCKET_FILTER &&
> >              type != BPF_PROG_TYPE_CGROUP_SKB &&
> 
> You should extend this if () statement instead of adding another
> if () below.

Reworking the if-statement is possible but the result is something like:

        if ((type != BPF_PROG_TYPE_SOCKET_FILTER &&
             type != BPF_PROG_TYPE_CGROUP_SKB &&
             !capable(CAP_SYS_ADMIN)) &&
            !((type == BPF_PROG_TYPE_SCHED_CLS ||
               type == BPF_PROG_TYPE_XDP) &&
              capable(CAP_NET_ADMIN)))
                return -EPERM;

This is not really readable and I do prefer an easy to verify code
when it comes to security, so how about the following version:

Signed-off-by: Andreas Steinmetz <ast@domdv.de>

--- a/kernel/bpf/syscall.c	2019-05-28 18:00:40.472841432 +0200
+++ b/kernel/bpf/syscall.c	2019-06-05 12:34:48.197107612 +0200
@@ -1559,10 +1559,18 @@ static int bpf_prog_load(union bpf_attr
 
 	if (attr->insn_cnt == 0 || attr->insn_cnt > BPF_MAXINSNS)
 		return -E2BIG;
-	if (type != BPF_PROG_TYPE_SOCKET_FILTER &&
-	    type != BPF_PROG_TYPE_CGROUP_SKB &&
-	    !capable(CAP_SYS_ADMIN))
-		return -EPERM;
+	switch (type) {
+	case BPF_PROG_TYPE_SOCKET_FILTER:
+	case BPF_PROG_TYPE_CGROUP_SKB:
+		break;
+	case BPF_PROG_TYPE_SCHED_CLS:
+	case BPF_PROG_TYPE_XDP:
+		if (capable(CAP_NET_ADMIN))
+			break;
+	default:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+	}
 
 	bpf_prog_load_fixup_attach_type(attr);
 	if (bpf_prog_load_check_attach_type(type, attr->expected_attach_type))

