Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E64C63EFB5D
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 08:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240454AbhHRGKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 02:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239485AbhHRGJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 02:09:43 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A24CC0612AD
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:06:03 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id n12so1146435plf.4
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NbUwFOYf9QoLFM9o1nAVztc6nEJjeod+Gi+09Yoftqs=;
        b=AA8Dm35avczwDjy1quR0mKKgLjJMquju7U+lNNFVsOZUn5KeyzjnQXjClbgpdlxX3v
         2SCBsrMQ7ukd+uf8c6Etiiy64mFHHfp2eOjZzOj3u12Lg1Ng2Us4VyORw9XhVSTq8vtw
         HHhuGPccj0u5QnTYM0PtIjxC8fm4Xv9eP4lFk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NbUwFOYf9QoLFM9o1nAVztc6nEJjeod+Gi+09Yoftqs=;
        b=bk/VrRnxXvyV/2k/JkGtQe6cfTeW7Ba113yrn6RYdTaUXBWmnEpUTXifa8OSAbmbu6
         5D0rAkAFayVIJrrPtzpY+ov0vCHOEXA+3XHcg2q1256u5vz4jT2uNmiRlgQbfXFxTgeP
         15iDi/18njs6vlXS02G6XkgNeSXDvZutsj46iv1AB4E+3GSKahsk2ITTwLqOXT1OGlED
         YEqNvZI/s+7E00mGM05fCt3Eddp8+sT3iNd0pmaLE7GrkIVQBmo1pdObZgWtTVFYe1+t
         lY23pkguB5IpVOP5H5t9vOtEZI8aD/lKiRDUhGgDeMugDaJgflVk7FkiNYYvzcntge+s
         CEDw==
X-Gm-Message-State: AOAM530QAeSzVI+bPGhr0Kpuhwml9Eqj6IUtobHdmm+RCciic/317Xmj
        7VTF4od3EgmDJ+bUOTG4SAFR/g==
X-Google-Smtp-Source: ABdhPJzgTBNMg0giRn1OlPz6IBm3E5s5bSOA2j6yOGDn8/0pIG8aKiyQ3az6o2cvg6kyztHJaHQzMQ==
X-Received: by 2002:a17:902:d2c3:b0:12d:8ce5:5b7d with SMTP id n3-20020a170902d2c300b0012d8ce55b7dmr6022538plc.67.1629266762932;
        Tue, 17 Aug 2021 23:06:02 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 20sm4769310pfi.170.2021.08.17.23.05.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 23:06:02 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-staging@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kbuild@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2 36/63] scsi: ibmvscsi: Avoid multi-field memset() overflow by aiming at srp
Date:   Tue, 17 Aug 2021 23:05:06 -0700
Message-Id: <20210818060533.3569517-37-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210818060533.3569517-1-keescook@chromium.org>
References: <20210818060533.3569517-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1793; h=from:subject; bh=5Fef3h9MfV87icL3aKSaHfIze5Oq4yInxr2gg/s9eAg=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhHKMm17KLki3rqBaWpe95fASVBBQIIBI5vmXQYfcS JgzP+3CJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYRyjJgAKCRCJcvTf3G3AJn/GEA C0g1tF3vBSATxFlt9g2MNVHox82GGsf3qtgn9DL9516BujVpZ6kxxymzVqHQLiePOpV9iTyZhh8bJP WPrCjTBFFiAdb9Faz4yuO9NudbXOZ+FexNaG3BvwuZOEhhxFRk3UBhjg0yj+oUvaQFJI+eTXM87IiX XGBr1KfDdlwjfoNhrhvn+4x2NL1tTH2qiRtqPMKANljnd20L8dSa0Zf11kG3d+/5Pg3jlBdf5oFQ4U LAOUjEVvApr+/BCqpBDdWYLpXpnN6wBAOl/UKC2lE4+Bma8jAela+AXthAZ4+UkXlllUyJC7CYFuYC nNiMaWOxnlHpbs9rLdSPcik2ntQ+SzdHUvwQ6D98tTmN5hOsvVqKypYT3ih1P0V3tx5tnqBrY3146X db+XSYqsKceUuA6bnZUACjEVi2zDnJZN/ekJ/ihxxqVKhs9MGGBJk2lEf1aYuZL0wluSpQwGxJSRs+ 3TlPDK7rkiGCZ7rOUhBMieRFjYzAx2KdDP5B2vjJOI/xopH9WIrkKC46i/Nbijs4Tk/P6zfRhrnq3h VCi/Zuk8ZQvxwMdoc18EPHLm7+Q+Sti54Kj1u5YIGU/ibkC2dYtnH1OTLV3w/X4I14RtR5sSFhYudo sHSg/VA5WHaBn3O1xg6slKTE5ifCxA4C+jndEj5364mN8eVDW0pyOK+Bp0vw==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memset(), avoid intentionally writing across
neighboring fields.

Instead of writing beyond the end of evt_struct->iu.srp.cmd, target the
upper union (evt_struct->iu.srp) instead, as that's what is being wiped.

Cc: Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
Link: https://lore.kernel.org/lkml/yq135rzp79c.fsf@ca-mkp.ca.oracle.com
Acked-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Link: https://lore.kernel.org/lkml/6eae8434-e9a7-aa74-628b-b515b3695359@linux.ibm.com
---
 drivers/scsi/ibmvscsi/ibmvscsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 50df7dd9cb91..ea8e01f49cba 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -1055,8 +1055,9 @@ static int ibmvscsi_queuecommand_lck(struct scsi_cmnd *cmnd,
 		return SCSI_MLQUEUE_HOST_BUSY;
 
 	/* Set up the actual SRP IU */
+	BUILD_BUG_ON(sizeof(evt_struct->iu.srp) != SRP_MAX_IU_LEN);
+	memset(&evt_struct->iu.srp, 0x00, sizeof(evt_struct->iu.srp));
 	srp_cmd = &evt_struct->iu.srp.cmd;
-	memset(srp_cmd, 0x00, SRP_MAX_IU_LEN);
 	srp_cmd->opcode = SRP_CMD;
 	memcpy(srp_cmd->cdb, cmnd->cmnd, sizeof(srp_cmd->cdb));
 	int_to_scsilun(lun, &srp_cmd->lun);
-- 
2.30.2

