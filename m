Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 862953F9C4E
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 18:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245468AbhH0QSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 12:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245377AbhH0QS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 12:18:28 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE71FC061796
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 09:17:39 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 17so6368873pgp.4
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 09:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PpE3AD8eCxkq5tJ/76g5xkddl9cPG+SrwUT4D+L1j9M=;
        b=PTuUn80HoLhaJHYCP7XyumnxfjHBpHlaOH8dvc9A+77jDWBiFwpof2Hbr0Ax+XMQ7X
         Uq95i61xse+X9GVAAmvNI7JtRH1mxT+CkyhUQCoW8SPNHyP1XyWWar/ZkHusyNYzyhTk
         m/FgwR5I6I6GjP+eCQEc2GAtdCKzCkL3ZCrvo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PpE3AD8eCxkq5tJ/76g5xkddl9cPG+SrwUT4D+L1j9M=;
        b=IFTsg7EoFoJP62R6jfgIu13mRRIx9KeZPVgy6w+gKzTCi4iDfi3vGS6d+M5AzdSk6q
         UxY5ehLgY0HN1iit0+wlKDZo4K2jXcp8futRx54BgtNByjo35q2m4GwEnw6g0srr1ZK6
         LnY8IkF5FPwWSVQVAzxx3XcvuMwsHzebpOqu7DXdKniZwH34DLua5wIcMVpIMAiFyhQL
         BgHnyYJb+jLxUpzIHCs9VWw7L4SFNOzHzdHhjxEnw70VMTT0BdlRsWW6bNQfdVphSqbR
         eCiG70mIxAtgCEnW+BouYQP6Rx2DnqzBqYsb19HUnHQYrFnoIULkuVi/GB/i1JTb+zpN
         qwzA==
X-Gm-Message-State: AOAM532WjaTGszaGvKM46ZBKcufqSzSjaHgY49O2SOQ7e9A0G0uRV095
        XP8UhEfC8ErdkIz9nMlpD+0ClQ==
X-Google-Smtp-Source: ABdhPJw/t8YOl1nXk3QdPbWpwbPMUYpww4D2dqTkc0FJGW4t+oJnaLp5x7c5LQiINxHw5PXRusXtVw==
X-Received: by 2002:a63:79c7:: with SMTP id u190mr8361038pgc.355.1630081059098;
        Fri, 27 Aug 2021 09:17:39 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y67sm6883595pfg.218.2021.08.27.09.17.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 09:17:38 -0700 (PDT)
Date:   Fri, 27 Aug 2021 09:17:37 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Luca Coelho <luciano.coelho@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        linux-crypto@vger.kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-can@vger.kernel.org,
        bpf@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Keith Packard <keithp@keithp.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        clang-built-linux@googlegroups.com, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 2/5] treewide: Replace open-coded flex arrays in unions
Message-ID: <202108270915.B4DD070AF@keescook>
References: <20210826050458.1540622-1-keescook@chromium.org>
 <20210826050458.1540622-3-keescook@chromium.org>
 <20210826062452.jekmoo43f4xu5jxk@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210826062452.jekmoo43f4xu5jxk@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 26, 2021 at 08:24:52AM +0200, Marc Kleine-Budde wrote:
> [...]
> BTW: Is there opportunity for conversion, too?
> 
> | drivers/net/can/peak_canfd/peak_pciefd_main.c:146:32: warning: array of flexible structures

Untested potential solution:

diff --git a/drivers/net/can/peak_canfd/peak_pciefd_main.c b/drivers/net/can/peak_canfd/peak_pciefd_main.c
index 1df3c4b54f03..efa2b5a52bd7 100644
--- a/drivers/net/can/peak_canfd/peak_pciefd_main.c
+++ b/drivers/net/can/peak_canfd/peak_pciefd_main.c
@@ -143,7 +143,11 @@ struct pciefd_rx_dma {
 	__le32 irq_status;
 	__le32 sys_time_low;
 	__le32 sys_time_high;
-	struct pucan_rx_msg msg[];
+	/*
+	 * with "msg" being pciefd_irq_rx_cnt(priv->irq_status)-many
+	 * variable-sized struct pucan_rx_msg following.
+	 */
+	__le32 msg[];
 } __packed __aligned(4);
 
 /* Tx Link record */
@@ -327,7 +331,7 @@ static irqreturn_t pciefd_irq_handler(int irq, void *arg)
 
 	/* handle rx messages (if any) */
 	peak_canfd_handle_msgs_list(&priv->ucan,
-				    rx_dma->msg,
+				    (struct pucan_rx_msg *)rx_dma->msg,
 				    pciefd_irq_rx_cnt(priv->irq_status));
 
 	/* handle tx link interrupt (if any) */


It's not great, but it's also not strictly a flex array, in the sense
that since struct pucan_rx_msg is a variable size, the compiler cannot
reason about the size of struct pciefd_rx_dma based only on the
irq_status encoding...

-- 
Kees Cook
