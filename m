Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB1354498D
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 12:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243276AbiFIK6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 06:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233559AbiFIK54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 06:57:56 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4978115D
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 03:57:55 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id bo5so20777779pfb.4
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 03:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=08yaUrB8txf7e26vAqrYciQJ0chivb/ZdBm5Snn0/v0=;
        b=G0YznXnPO5PeRDEjEegjcLa5+eso3BEkH1+IXDwlmcNAqms4TLXVtg99ZKlWGdWkGP
         763PUqFnqcgoI8s/1kJv0Op7CLOsdk5xuGuYShxcCnKYNkVMeS4D8jK+uJV64MUnEfSK
         reRJptsIjpZ1bnZ6yA0yzaulq0x2W39Z/2Eo3aGWAIgmW+q7sRIW9A/uSgstZSezsp+R
         yt/Njhq1hk6Ys5tcNiLaAbqoRgaiaOQ54qfVnE5fcxIbfWbNRzQMCpTAMr6agj8lXqLW
         0xzZYBFFUA7ct6TKBFv98vDFeO23PzD0SRQ9AR7PLlBfP3EZWSDg7l+KWaGR/U0+syca
         hM7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=08yaUrB8txf7e26vAqrYciQJ0chivb/ZdBm5Snn0/v0=;
        b=bjVCvlVD1agrY36nFIwPp4YPlz78PW83eLrQ45IkO6hUpWTHbE0fjC5bolqHbO4PKb
         5GFaOSFvvNum/fVr+xLSusAKNJnwQudIgmbCgjjcNro6BBW4288ApmIWDkIFejmBopvc
         OlfPnOlAUHkmm1Qm2zCICDI+GeQHF6WPvVaV+qfJh5uYEnSTTsZwDvC9ad5hoi/B/dyV
         1TLY9PxHzGwEeUirDLQNidOEJT8BVYKzvpk5HuZPQEtOlfsHJN9MFl8sV0PPRYSpLfr8
         O8rYkb5UoYm35wbe5nuU/xf+lt93QQ1yJYvpyfgh5lBFpnappiyRb6Ro0FrYjlu3tLRN
         LrIw==
X-Gm-Message-State: AOAM531+nmZ0SqyoyW6gWeB7ulRWNDSwO0iLJiIui3+iiw8pSSwwEqwk
        F9ShX/U6ionOCKCCyq88edI=
X-Google-Smtp-Source: ABdhPJz/Za0Qu4H8YvSk17lNbAmkIaJ85vTvBsB0Y1v7t7yWY9qYiSF8UzgYEDiCyh7cUXRRtUwItw==
X-Received: by 2002:a63:210e:0:b0:3fd:9c07:7670 with SMTP id h14-20020a63210e000000b003fd9c077670mr19930214pgh.222.1654772275218;
        Thu, 09 Jun 2022 03:57:55 -0700 (PDT)
Received: from nvm-geerzzfj.. ([49.7.38.61])
        by smtp.gmail.com with ESMTPSA id d82-20020a621d55000000b005184fe6cc99sm16949338pfd.29.2022.06.09.03.57.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 03:57:55 -0700 (PDT)
From:   Yuwei Wang <wangyuweihx@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com
Cc:     daniel@iogearbox.net, roopa@nvidia.com, dsahern@kernel.org,
        qindi@staff.weibo.com, netdev@vger.kernel.org,
        Yuwei Wang <wangyuweihx@gmail.com>
Subject: [PATCH net-next v3 1/2] sysctl: add proc_dointvec_jiffies_minmax
Date:   Thu,  9 Jun 2022 10:57:24 +0000
Message-Id: <20220609105725.2367426-2-wangyuweihx@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220609105725.2367426-1-wangyuweihx@gmail.com>
References: <20220609105725.2367426-1-wangyuweihx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add proc_dointvec_jiffies_minmax to fit jiffies param with a limited
range of values

Signed-off-by: Yuwei Wang <wangyuweihx@gmail.com>
---
 include/linux/sysctl.h |  2 ++
 kernel/sysctl.c        | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 80263f7cdb77..0e1c05244350 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -75,6 +75,8 @@ int proc_douintvec_minmax(struct ctl_table *table, int write, void *buffer,
 int proc_dou8vec_minmax(struct ctl_table *table, int write, void *buffer,
 			size_t *lenp, loff_t *ppos);
 int proc_dointvec_jiffies(struct ctl_table *, int, void *, size_t *, loff_t *);
+int proc_dointvec_jiffies_minmax(struct ctl_table *table, int write,
+		void *buffer, size_t *lenp, loff_t *ppos);
 int proc_dointvec_userhz_jiffies(struct ctl_table *, int, void *, size_t *,
 		loff_t *);
 int proc_dointvec_ms_jiffies(struct ctl_table *, int, void *, size_t *,
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index e52b6e372c60..4187c389a1eb 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1189,6 +1189,31 @@ static int do_proc_dointvec_jiffies_conv(bool *negp, unsigned long *lvalp,
 	return 0;
 }
 
+static int do_proc_dointvec_jiffies_minmax_conv(bool *negp, unsigned long *lvalp,
+						int *valp, int write, void *data)
+{
+	int tmp, ret;
+	struct do_proc_dointvec_minmax_conv_param *param = data;
+	/*
+	 * If writing, first do so via a temporary local int so we can
+	 * bounds-check it before touching *valp.
+	 */
+	int *ip = write ? &tmp : valp;
+
+	ret = do_proc_dointvec_jiffies_conv(negp, lvalp, ip, write, data);
+	if (ret)
+		return ret;
+
+	if (write) {
+		if ((param->min && *param->min > tmp) ||
+				(param->max && *param->max < tmp))
+			return -EINVAL;
+		*valp = tmp;
+}
+
+return 0;
+}
+
 static int do_proc_dointvec_userhz_jiffies_conv(bool *negp, unsigned long *lvalp,
 						int *valp,
 						int write, void *data)
@@ -1259,6 +1284,17 @@ int proc_dointvec_jiffies(struct ctl_table *table, int write,
 		    	    do_proc_dointvec_jiffies_conv,NULL);
 }
 
+int proc_dointvec_jiffies_minmax(struct ctl_table *table, int write,
+			  void *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct do_proc_dointvec_minmax_conv_param param = {
+		.min = (int *) table->extra1,
+		.max = (int *) table->extra2,
+	};
+	return do_proc_dointvec(table, write, buffer, lenp, ppos,
+			do_proc_dointvec_jiffies_minmax_conv, &param);
+}
+
 /**
  * proc_dointvec_userhz_jiffies - read a vector of integers as 1/USER_HZ seconds
  * @table: the sysctl table
-- 
2.34.1

