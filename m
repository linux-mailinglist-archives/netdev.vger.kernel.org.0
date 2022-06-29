Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C744F55FB14
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 10:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbiF2Ix6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 04:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbiF2Ix4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 04:53:56 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ABFA3B3DE
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 01:53:55 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id i8-20020a17090aee8800b001ecc929d14dso833919pjz.0
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 01:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ztdRYmrrwDFseGrJ4VibDTAR9vIvAp47d87V542cPI0=;
        b=d85Yv5BReGTbP35b9lpDINHK1E4gHsweaFdjjNkvBRLxdDHcy0RSTLzWhZplYQMmYK
         Zs4w4yqHB1jkIZVEeJiieBE+hC8ggl2xnoVGDXF9yU8fyXD6mEUsDls4dYgCHFd2aBho
         K+dgBAReL7JlS4pnPO4+ACT/P9syl8f6mxBfyfsMH1xMlkZFW09FfXiMFoWquYK+hbIr
         eH5+iKCQnHMvGyn3qEa6fRVKCGXbzNVn4V6aA1JqW66sSed0IYKsvB9PAeri19RSNDk2
         D+Qg2H0bOXlxEFxyLgjRQ0iiMIg+xpFggRu6Uq/6+EbtpB6gSp5OQDEZN+P89NInnKOC
         cKUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ztdRYmrrwDFseGrJ4VibDTAR9vIvAp47d87V542cPI0=;
        b=r02xLNHn2dhz7wvVMrbaYKfm7ZAGOkx6D5scUMJAc+AAjy+FCvBNp9hb6PS2PcNtlv
         w+AJ8FtBdmcO6ocAFtYOb1hg+/D27mhCfs0f+wKPuTqk4CrjHoaXNzY0QlSq9SXF1CqI
         r+EQq4+vmHxdcfJ5dTUmzIx1DngAnElL5tq/jXThRP0c8cAGlEcWxBvlLmpO3AUlQmuu
         laBUNXXMdTXx3XqdMPDfdCLF7Foc8pYoZud//7YyvOkVdLU8usJvHScOuaUgdfmf0LX5
         1I5qEl4wVFC0DYZYVMLoGHsoPtAONpzpocs8WcjOBcU3lsXaFlBvE/FS4eO+4oyMzde1
         1F1g==
X-Gm-Message-State: AJIora/YCdiAFxKKb9qeuClqi127PNsGswPDc69wAjf+RkC0xZ1u9YdG
        F4yxSwTP0eJHAjQWGxJoZ2w=
X-Google-Smtp-Source: AGRyM1twPrlvFrOriaSTGrfM4x1/SmRaPN9N1yo1HpXzRSwBH3iMa+kBX6hsFH2zXsIloFHlzDcJ+w==
X-Received: by 2002:a17:903:2281:b0:16a:6604:d1d8 with SMTP id b1-20020a170903228100b0016a6604d1d8mr8007298plh.78.1656492835121;
        Wed, 29 Jun 2022 01:53:55 -0700 (PDT)
Received: from nvm-geerzzfj.. ([103.142.140.73])
        by smtp.gmail.com with ESMTPSA id y19-20020a17090aca9300b001e0c5da6a51sm1425724pjt.50.2022.06.29.01.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 01:53:54 -0700 (PDT)
From:   Yuwei Wang <wangyuweihx@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, daniel@iogearbox.net
Cc:     roopa@nvidia.com, dsahern@kernel.org, qindi@staff.weibo.com,
        netdev@vger.kernel.org, Yuwei Wang <wangyuweihx@gmail.com>
Subject: [PATCH net-next v4 1/2] sysctl: add proc_dointvec_ms_jiffies_minmax
Date:   Wed, 29 Jun 2022 08:48:31 +0000
Message-Id: <20220629084832.2842973-2-wangyuweihx@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220629084832.2842973-1-wangyuweihx@gmail.com>
References: <20220629084832.2842973-1-wangyuweihx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add proc_dointvec_ms_jiffies_minmax to fit read msecs value to jiffies
with a limited range of values

Signed-off-by: Yuwei Wang <wangyuweihx@gmail.com>
---
 include/linux/sysctl.h |  2 ++
 kernel/sysctl.c        | 41 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 80263f7cdb77..17b42ce89d3e 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -75,6 +75,8 @@ int proc_douintvec_minmax(struct ctl_table *table, int write, void *buffer,
 int proc_dou8vec_minmax(struct ctl_table *table, int write, void *buffer,
 			size_t *lenp, loff_t *ppos);
 int proc_dointvec_jiffies(struct ctl_table *, int, void *, size_t *, loff_t *);
+int proc_dointvec_ms_jiffies_minmax(struct ctl_table *table, int write,
+		void *buffer, size_t *lenp, loff_t *ppos);
 int proc_dointvec_userhz_jiffies(struct ctl_table *, int, void *, size_t *,
 		loff_t *);
 int proc_dointvec_ms_jiffies(struct ctl_table *, int, void *, size_t *,
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index e52b6e372c60..85c92e2c2570 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1237,6 +1237,30 @@ static int do_proc_dointvec_ms_jiffies_conv(bool *negp, unsigned long *lvalp,
 	return 0;
 }
 
+static int do_proc_dointvec_ms_jiffies_minmax_conv(bool *negp, unsigned long *lvalp,
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
+	ret = do_proc_dointvec_ms_jiffies_conv(negp, lvalp, ip, write, data);
+	if (ret)
+		return ret;
+
+	if (write) {
+		if ((param->min && *param->min > tmp) ||
+				(param->max && *param->max < tmp))
+			return -EINVAL;
+		*valp = tmp;
+	}
+	return 0;
+}
+
 /**
  * proc_dointvec_jiffies - read a vector of integers as seconds
  * @table: the sysctl table
@@ -1259,6 +1283,17 @@ int proc_dointvec_jiffies(struct ctl_table *table, int write,
 		    	    do_proc_dointvec_jiffies_conv,NULL);
 }
 
+int proc_dointvec_ms_jiffies_minmax(struct ctl_table *table, int write,
+			  void *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct do_proc_dointvec_minmax_conv_param param = {
+		.min = (int *) table->extra1,
+		.max = (int *) table->extra2,
+	};
+	return do_proc_dointvec(table, write, buffer, lenp, ppos,
+			do_proc_dointvec_ms_jiffies_minmax_conv, &param);
+}
+
 /**
  * proc_dointvec_userhz_jiffies - read a vector of integers as 1/USER_HZ seconds
  * @table: the sysctl table
@@ -1523,6 +1558,12 @@ int proc_dointvec_jiffies(struct ctl_table *table, int write,
 	return -ENOSYS;
 }
 
+int proc_dointvec_ms_jiffies_minmax(struct ctl_table *table, int write,
+				    void *buffer, size_t *lenp, loff_t *ppos)
+{
+	return -ENOSYS;
+}
+
 int proc_dointvec_userhz_jiffies(struct ctl_table *table, int write,
 		    void *buffer, size_t *lenp, loff_t *ppos)
 {
-- 
2.34.1

