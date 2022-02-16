Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D246B4B9264
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 21:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232365AbiBPUgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 15:36:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233113AbiBPUf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 15:35:59 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661B92A416E
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 12:35:46 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id bn33so5159216ljb.6
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 12:35:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=Frf9RHfM4Wu/m6Ti4jFHD52YeRNbCqVot/8g7bXmkvw=;
        b=EGZqKCufcjEKSqA/ZUaVuGaIoxc5UkwEQmEaBONxQd584DFtd3ucJg9owSyf3G2omb
         dZP/dhxugzjBE5+eYeZqftOXNUlt0b/T6uxcG5Hm0ij6xHYUoG2EQMpFPL1MJrphTNN4
         TntJnN1bEm/M5+iSOc/zboUAXrm3kC758F5rCC6AWu8MTPE/O0cX86vUMXHGsChHnwtD
         DIaaKrrFqElgL3Js6pSQMPdIGloOIUSsPGFxJsSiFistk5AAGAHjZpe95OcoggfEc48L
         fKSRKHbnsdykdMAl+vUHY+01/ikqWMbFN+xD0/fyRFnejHhqmiTXF33D/GMgSgazzd20
         D22Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=Frf9RHfM4Wu/m6Ti4jFHD52YeRNbCqVot/8g7bXmkvw=;
        b=uuBK5oTz929IA7mZliZSk7YcEWjifqjEUV5ChpllIQEUo0zCfOzPkMEAg5HrX2WcPj
         fr3w1Wsfj5fgyKEQd36oBKmN6unMoVkk0Qs6PN0hHHisI59W2vSbt6ebQ1JwJKP1mJM/
         O5j0pgKsZwewkjHIqvrGA3zi6de8zo+YelZwLiw3TtYXwYubRVcx6W2Vs/0NoVMdu9pk
         YGSPhZFF0shey/sXenh4kfNQMWUW9bK0V8rkgnS+fD7Ti42nKmBr6GxMvM2tUs3LuttQ
         B3JyDkXVgYBN3rSn/kAN2ISn6hhSpK0O0ajfm/F6tkV7NiETkEzqvgyiSVdhWNW08Gza
         aKLQ==
X-Gm-Message-State: AOAM53026Wqc8u/T6zogxqke0dJ4QypCGBBI7x6sUWhLvWxwvnSpYCWZ
        kO12UCeirRmYj6CWIIZo+sq6nRfJ2p0=
X-Google-Smtp-Source: ABdhPJxcxIRKirU/iLb3P25FyR8pLd24eucA5vWmF/qEQytYgASkthBfzcfrBpIE3PLTtz/4g/fjbA==
X-Received: by 2002:a2e:995:0:b0:244:e3d0:78d8 with SMTP id 143-20020a2e0995000000b00244e3d078d8mr3507542ljj.172.1645043744441;
        Wed, 16 Feb 2022 12:35:44 -0800 (PST)
Received: from [192.168.88.200] (pppoe.178-66-239-7.dynamic.avangarddsl.ru. [178.66.239.7])
        by smtp.gmail.com with ESMTPSA id 2sm196263lji.62.2022.02.16.12.35.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Feb 2022 12:35:44 -0800 (PST)
Message-ID: <bd64b479-9d0e-cec8-d57a-5f188a822dd9@gmail.com>
Date:   Wed, 16 Feb 2022 23:35:43 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
From:   Maxim Petrov <mmrmaximuzz@gmail.com>
Subject: [PATCH v2 iproute2] lnstat: fix strdup leak in -w argument parsing
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'tmp' string is copied for safe tokenizing, but it is not required after
getting all the widths in -w option. Use strdupa instead of strdup to avoid
explicit memory leak and to not trigger valgrind here.

Signed-off-by: Maxim Petrov <mmrmaximuzz@gmail.com>
---
Changes in V2:
* Use strdupa instead of strdup/free

 misc/lnstat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/misc/lnstat.c b/misc/lnstat.c
index 98904d45..d7e1d8c9 100644
--- a/misc/lnstat.c
+++ b/misc/lnstat.c
@@ -314,7 +314,7 @@ int main(int argc, char **argv)
 			sscanf(optarg, "%u", &hdr);
 			break;
 		case 'w':
-			tmp = strdup(optarg);
+			tmp = strdupa(optarg);
 			if (!tmp)
 				break;
 			i = 0;
-- 
2.25.1
