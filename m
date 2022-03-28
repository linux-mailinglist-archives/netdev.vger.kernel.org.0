Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11BE04EA0D4
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 21:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245313AbiC1T4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 15:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232294AbiC1T4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 15:56:01 -0400
Received: from stuerz.xyz (unknown [45.77.206.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12EA1B13;
        Mon, 28 Mar 2022 12:54:19 -0700 (PDT)
Received: by stuerz.xyz (Postfix, from userid 114)
        id 3B250FA71D; Mon, 28 Mar 2022 19:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648497258; bh=vLujta4nZyWs+WRhXVDs/r9cMmB7D9buGBDSpH905nQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Yn49FpLcNYkEPaqVCB+mlfSyG/bPPHG2t194EzTcGPaC/nM6rV3/RBwyIv/EqPxqr
         eU31BGDKBFVvILCvvBjSWoZ0mBJzFQpD/CW0feRKghfhyeMKeM6ivADRbIJSOqZ+0s
         Uq8j3GtApWGBGuSEa9RrgT3vp5wfNaP63p01YhA+/+SW96iCiHPg1QfQpu1Wrb8/fI
         FQSGutgQVFYrTkWH04ibID/JwKRDtF6Z6ry3mRPDF/Z5GZa790v7pXCanGJbgocNyO
         PLG20VlLzx5VoiIQHje4gj8NvrxixMlBdj/dYCpmTDAUxFp4lYzW1mYbT+HZfoQPec
         DPnv+ugxfeWKQ==
Received: from [IPV6:2a02:8109:a100:1a48:ff0:ef2f:d4da:17d8] (unknown [IPv6:2a02:8109:a100:1a48:ff0:ef2f:d4da:17d8])
        by stuerz.xyz (Postfix) with ESMTPSA id E7D78FA6B1;
        Mon, 28 Mar 2022 19:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648497255; bh=vLujta4nZyWs+WRhXVDs/r9cMmB7D9buGBDSpH905nQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=RtLxYW4DBUyyHTFQEL882cfZ2TUySc5QkJJC3ZkaaYG0ptDes5KHHO4xJ+kIgtKAg
         STWYNCCwYyJSaBybQR5XU2DdrBJ8Gtj0eiVu9BZqnULzAykR5unK/FBX9bdWqeIZCs
         3HUccN3oyf4iMFW6WbsZyjQPMOYq6M3pZ0HlufcIDinhylPIR67J7Dq0f5KP7d/fRh
         KRnsh+3OaZc5yM03avILSMBdBMbfMy+2JdqY0hffJIsPIV7zgNH9C1E34dhezUoZwo
         YKrhD7zHwq2Ev+f/uW/sR5IIJMgliEuWEhu4EfciEB9N/UhFJXKJ4JyYeUEwxGXICg
         5ckAvpmEYAOVw==
Message-ID: <6cae7be8-0329-7b0f-9a61-695f3d0cceb4@stuerz.xyz>
Date:   Mon, 28 Mar 2022 21:54:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: [PATCH 20/22 v3] ray_cs: Improve card_status[]
Content-Language: en-US
To:     Joe Perches <joe@perches.com>, Kalle Valo <kvalo@kernel.org>
Cc:     kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220326165909.506926-20-benni@stuerz.xyz>
 <164846920750.11945.16978682699891961444.kvalo@kernel.org>
 <1b694c4c-100b-951a-20f7-df1c912bb550@stuerz.xyz>
 <683c72536c0672aa69c285ee505ec552fa76935f.camel@perches.com>
From:   =?UTF-8?Q?Benjamin_St=c3=bcrz?= <benni@stuerz.xyz>
In-Reply-To: <683c72536c0672aa69c285ee505ec552fa76935f.camel@perches.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,RDNS_DYNAMIC,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.03.22 21:23, Joe Perches wrote:
> On Mon, 2022-03-28 at 20:21 +0200, Benjamin Stürz wrote:
>> Replace comments with C99's designated initializers.
> []
>> diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
> []
>> @@ -2529,20 +2529,23 @@ static void clear_interrupt(ray_dev_t *local)
>>  #define MAXDATA (PAGE_SIZE - 80)
>>
>>  static const char *card_status[] = {
>> -	"Card inserted - uninitialized",	/* 0 */
>> -	"Card not downloaded",			/* 1 */
>> -	"Waiting for download parameters",	/* 2 */
>> -	"Card doing acquisition",		/* 3 */
>> -	"Acquisition complete",			/* 4 */
>> -	"Authentication complete",		/* 5 */
>> -	"Association complete",			/* 6 */
>> -	"???", "???", "???", "???",		/* 7 8 9 10 undefined */
>> -	"Card init error",			/* 11 */
>> -	"Download parameters error",		/* 12 */
>> -	"???",					/* 13 */
>> -	"Acquisition failed",			/* 14 */
>> -	"Authentication refused",		/* 15 */
>> -	"Association failed"			/* 16 */
>> +	[0]  = "Card inserted - uninitialized",
> 
> If you are going to do this at all, please use the #defines
> in drivers/net/wireless/rayctl.h
> 
> 	[CARD_INSERTED] = "Card inserted - uninitialized",
> 	[CARD_AWAITING_PARAM] = "Card not downloaded",
> 
> etc...
> 
> $ git grep -w -P 'CARD_\w+' drivers/net/wireless/rayctl.h
> drivers/net/wireless/rayctl.h:#define CARD_INSERTED       (0)
> drivers/net/wireless/rayctl.h:#define CARD_AWAITING_PARAM (1)
> drivers/net/wireless/rayctl.h:#define CARD_INIT_ERROR     (11)
> drivers/net/wireless/rayctl.h:#define CARD_DL_PARAM       (2)
> drivers/net/wireless/rayctl.h:#define CARD_DL_PARAM_ERROR (12)
> drivers/net/wireless/rayctl.h:#define CARD_DOING_ACQ      (3)
> drivers/net/wireless/rayctl.h:#define CARD_ACQ_COMPLETE   (4)
> drivers/net/wireless/rayctl.h:#define CARD_ACQ_FAILED     (14)
> drivers/net/wireless/rayctl.h:#define CARD_AUTH_COMPLETE  (5)
> drivers/net/wireless/rayctl.h:#define CARD_AUTH_REFUSED   (15)
> drivers/net/wireless/rayctl.h:#define CARD_ASSOC_COMPLETE (6)
> drivers/net/wireless/rayctl.h:#define CARD_ASSOC_FAILED   (16)
> 
>> +	[1]  = "Card not downloaded",
>> +	[2]  = "Waiting for download parameters",
>> +	[3]  = "Card doing acquisition",
>> +	[4]  = "Acquisition complete",
>> +	[5]  = "Authentication complete",
>> +	[6]  = "Association complete",
>> +	[7]  = "???",
>> +	[8]  = "???",
>> +	[9]  = "???",
>> +	[10] = "???",
>> +	[11] = "Card init error",
>> +	[12] = "Download parameters error",
>> +	[13] = "???",
>> +	[14] = "Acquisition failed",
>> +	[15] = "Authentication refused",
>> +	[16] = "Association failed"
>>  };
>>
>>  static const char *nettype[] = { "Adhoc", "Infra " };
> 
> 


- Make card_status[] const, because it should never be modified
- Replace comments with C99's designated initializers to improve
  readability and maintainability

Signed-off-by: Benjamin Stürz <benni@stuerz.xyz>
---
 drivers/net/wireless/ray_cs.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index 87e98ab068ed..07f36aaefbde 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -2528,21 +2528,24 @@ static void clear_interrupt(ray_dev_t *local)
 #ifdef CONFIG_PROC_FS
 #define MAXDATA (PAGE_SIZE - 80)

-static const char *card_status[] = {
-	"Card inserted - uninitialized",	/* 0 */
-	"Card not downloaded",			/* 1 */
-	"Waiting for download parameters",	/* 2 */
-	"Card doing acquisition",		/* 3 */
-	"Acquisition complete",			/* 4 */
-	"Authentication complete",		/* 5 */
-	"Association complete",			/* 6 */
-	"???", "???", "???", "???",		/* 7 8 9 10 undefined */
-	"Card init error",			/* 11 */
-	"Download parameters error",		/* 12 */
-	"???",					/* 13 */
-	"Acquisition failed",			/* 14 */
-	"Authentication refused",		/* 15 */
-	"Association failed"			/* 16 */
+static const char * const card_status[] = {
+	[CARD_INSERTED]		= "Card inserted - uninitialized",
+	[CARD_AWAITING_PARAM]	= "Card not downloaded",
+	[CARD_DL_PARAM]		= "Waiting for download parameters",
+	[CARD_DOING_ACQ]	= "Card doing acquisition",
+	[CARD_ACQ_COMPLETE]	= "Acquisition complete",
+	[CARD_AUTH_COMPLETE]	= "Authentication complete",
+	[CARD_ASSOC_COMPLETE]	= "Association complete",
+	[7]			= "???",
+	[8]			= "???",
+	[9]			= "???",
+	[10]			= "???",
+	[CARD_INIT_ERROR]	= "Card init error",
+	[CARD_DL_PARAM_ERROR]	= "Download parameters error",
+	[13]			= "???",
+	[CARD_ACQ_FAILED]	= "Acquisition failed",
+	[CARD_AUTH_REFUSED]	= "Authentication refused",
+	[CARD_ASSOC_FAILED]	= "Association failed"
 };

 static const char *nettype[] = { "Adhoc", "Infra " };
-- 
2.35.1
