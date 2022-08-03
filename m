Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0455588613
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 05:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbiHCDtP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 2 Aug 2022 23:49:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231693AbiHCDtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 23:49:13 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B9E0C1EEF8
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 20:49:09 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2733mlwH7027363, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2733mlwH7027363
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Wed, 3 Aug 2022 11:48:47 +0800
Received: from RTEXMBS02.realtek.com.tw (172.21.6.95) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 3 Aug 2022 11:48:55 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS02.realtek.com.tw (172.21.6.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Wed, 3 Aug 2022 11:48:55 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::d902:19b0:8613:5b97]) by
 RTEXMBS04.realtek.com.tw ([fe80::d902:19b0:8613:5b97%5]) with mapi id
 15.01.2375.007; Wed, 3 Aug 2022 11:48:55 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Oliver Neukum <oneukum@suse.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [RFC] r8152: pass through needs to be singular
Thread-Topic: [RFC] r8152: pass through needs to be singular
Thread-Index: AQHYorbkT7oEeBXrNkS3PRLAR8WbAK2cjJJw
Date:   Wed, 3 Aug 2022 03:48:55 +0000
Message-ID: <0f5422bbeb7642f492b99e9ec1f07751@realtek.com>
References: <20220728191851.30402-1-oneukum@suse.com>
In-Reply-To: <20220728191851.30402-1-oneukum@suse.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.203]
x-kse-serverinfo: RTEXMBS02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/8/3_=3F=3F_01:23:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Oliver Neukum <oneukum@suse.com>
> Sent: Friday, July 29, 2022 3:19 AM
[...]
> @@ -1608,6 +1622,12 @@ static int vendor_mac_passthru_addr_read(struct
> r8152 *tp, struct sockaddr *sa)
>  	acpi_object_type mac_obj_type;
>  	int mac_strlen;
> 
> +	mutex_lock(&pass_through_lock);
> +
> +	if (!holder_of_pass_through) {
> +		ret = -EBUSY;
> +		goto failout;
> +	}

Excuse me. I have one question.
When is the holder_of_pass_through set?
The default value of holder_of_pass_through is NULL, so
it seems the holder_of_pass_through would never be set.

Best Regards,
Hayes

>  	if (tp->lenovo_macpassthru) {
>  		mac_obj_name = "\\MACA";
>  		mac_obj_type = ACPI_TYPE_STRING;
> @@ -1621,7 +1641,8 @@ static int vendor_mac_passthru_addr_read(struct
> r8152 *tp, struct sockaddr *sa)
>  			if ((ocp_data & PASS_THRU_MASK) != 1) {
>  				netif_dbg(tp, probe, tp->netdev,
>  						"No efuse for RTL8153-AD MAC pass through\n");
> -				return -ENODEV;
> +				ret = -ENODEV;
> +				goto failout;
>  			}
>  		} else {
>  			/* test for RTL8153-BND and RTL8153-BD */
> @@ -1629,7 +1650,8 @@ static int vendor_mac_passthru_addr_read(struct
> r8152 *tp, struct sockaddr *sa)
>  			if ((ocp_data & BND_MASK) == 0 && (ocp_data & BD_MASK)
> == 0) {
>  				netif_dbg(tp, probe, tp->netdev,
>  						"Invalid variant for MAC pass through\n");
> -				return -ENODEV;
> +				ret = -ENODEV;
> +				goto failout;
>  			}
>  		}
> 
> @@ -1641,8 +1663,10 @@ static int vendor_mac_passthru_addr_read(struct
> r8152 *tp, struct sockaddr *sa)
>  	/* returns _AUXMAC_#AABBCCDDEEFF# */
>  	status = acpi_evaluate_object(NULL, mac_obj_name, NULL, &buffer);
>  	obj = (union acpi_object *)buffer.pointer;
> -	if (!ACPI_SUCCESS(status))
> -		return -ENODEV;
> +	if (!ACPI_SUCCESS(status)) {
> +		ret = -ENODEV;
> +		goto failout;
> +	}
>  	if (obj->type != mac_obj_type || obj->string.length != mac_strlen) {
>  		netif_warn(tp, probe, tp->netdev,
>  			   "Invalid buffer for pass-thru MAC addr: (%d, %d)\n",
> @@ -1670,6 +1694,10 @@ static int vendor_mac_passthru_addr_read(struct
> r8152 *tp, struct sockaddr *sa)
> 
>  amacout:
>  	kfree(obj);
> +failout:
> +	if (!ret)
> +		holder_of_pass_through = tp;
> +	mutex_unlock(&pass_through_lock);
>  	return ret;
>  }

