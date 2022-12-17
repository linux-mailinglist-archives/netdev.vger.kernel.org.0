Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62D0F64FC95
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 23:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbiLQWRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 17:17:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiLQWR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 17:17:29 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08347A45A
        for <netdev@vger.kernel.org>; Sat, 17 Dec 2022 14:17:29 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id jr11so5569223qtb.7
        for <netdev@vger.kernel.org>; Sat, 17 Dec 2022 14:17:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cnS3Pw6Dj87Il46h7I54ZB8bxMh9UKhiYH1/x8LD1yg=;
        b=Y4jo6t33DdKZiNQLmwHA3swNInesRUz8iCLUmV/PHLPgDoI9NFIt5HfYKUc/xIcoC2
         ppXbFbY5o+0ez5nvBOhXtKMrG7KUlymvonCniF0xsfNqs7VPcBTIkBRC+5R0tPHWRI/9
         9ibg4jPAJUCqrOxLYv4y2gxE+x20akKzvrtPanJO9YYRO4gz9mh0DWnkwoB6+hF6uPVT
         okX6hsEn5Xdax8IemlQUXWParf87AphSP/qrvsliCQL8CaKIr67gBpqrbV6zO6II3l7E
         CkfYfCSCbJ0bp0iRvQhL25aKmQuwKk2rBxkEI5KsdQMalQthfsHxMR2dvYZV92vynxk7
         WjHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cnS3Pw6Dj87Il46h7I54ZB8bxMh9UKhiYH1/x8LD1yg=;
        b=TVXqiKe5+580dzM3T7iGwDkK2nl03/Jjr+QgkERFcWtd45VYCRZQcukGU2RieWr9fF
         r59d3MJFngI3lnF6PGs64HLAy6pj+DxOpg+EaxVNZpHrT/569CJSTCsvIFSlO9SDW/1D
         wCe0Z1HYUqLg64hHFq4EQklpp5R3d0sDJlzYFlWT1enS2ySIOEcjGtFiRgYCSOIUj5Fy
         aXwvE1mudwOLxin8P4b/19JxWMJojOOkY+yBKBZN34Y8s67IemCxByjOrmUyZ3H0UJbY
         rBSJTJsOBkpqSGFG1aoHxxh7EUsTkEJjxTfWNshvhGPQtVYe7Ziqy4FFDEFqMBb4YQHC
         Jtyw==
X-Gm-Message-State: ANoB5pnWBQLwFUCfUH8RrIjSf3grXEhVPMopbhFbQ73sQdeIA3FtNLXY
        L+sx0CGfCV6vRkC0IZ3C2MXTdv1ZhFc=
X-Google-Smtp-Source: AA0mqf5DZ9ILYxqyHD70N8KLhDQHO9xTpr2zSNtr7aWJZrVG2p88M37qM55dcRX0JtnEzgRaq3JjqA==
X-Received: by 2002:ac8:1246:0:b0:3a7:648d:23ce with SMTP id g6-20020ac81246000000b003a7648d23cemr48860181qtj.25.1671315447861;
        Sat, 17 Dec 2022 14:17:27 -0800 (PST)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:90a:28dc:26a7:4000])
        by smtp.gmail.com with ESMTPSA id c12-20020ac81e8c000000b0039a08c0a594sm3603018qtm.82.2022.12.17.14.17.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Dec 2022 14:17:26 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <cong.wang@bytedance.com>,
        syzbot+4caeae4c7103813598ae@syzkaller.appspotmail.com,
        Jun Nie <jun.nie@linaro.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [Patch net] net_sched: reject TCF_EM_SIMPLE case for complex ematch module
Date:   Sat, 17 Dec 2022 14:17:07 -0800
Message-Id: <20221217221707.46010-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

When TCF_EM_SIMPLE was introduced, it is supposed to be convenient
for ematch implementation:

https://lore.kernel.org/all/20050105110048.GO26856@postel.suug.ch/

"You don't have to, providing a 32bit data chunk without TCF_EM_SIMPLE
set will simply result in allocating & copy. It's an optimization,
nothing more."

So if an ematch module provides ops->datalen that means it wants a
complex data structure (saved in its em->data) instead of a simple u32
value. We should simply reject such a combination, otherwise this u32
could be misinterpreted as a pointer.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-and-tested-by: syzbot+4caeae4c7103813598ae@syzkaller.appspotmail.com
Reported-by: Jun Nie <jun.nie@linaro.org>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/sched/ematch.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/ematch.c b/net/sched/ematch.c
index 4ce681361851..5c1235e6076a 100644
--- a/net/sched/ematch.c
+++ b/net/sched/ematch.c
@@ -255,6 +255,8 @@ static int tcf_em_validate(struct tcf_proto *tp,
 			 * the value carried.
 			 */
 			if (em_hdr->flags & TCF_EM_SIMPLE) {
+				if (em->ops->datalen > 0)
+					goto errout;
 				if (data_len < sizeof(u32))
 					goto errout;
 				em->data = *(u32 *) data;
-- 
2.34.1

