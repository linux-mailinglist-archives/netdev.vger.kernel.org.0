Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C89CD60F60C
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 13:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234755AbiJ0LSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 07:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234831AbiJ0LSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 07:18:48 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E17BBF88EF;
        Thu, 27 Oct 2022 04:18:46 -0700 (PDT)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 4022861EA192A;
        Thu, 27 Oct 2022 13:18:44 +0200 (CEST)
Message-ID: <abb598cd-c849-33b8-34fa-4cedcf185138@molgen.mpg.de>
Date:   Thu, 27 Oct 2022 13:18:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v1] Bluetooth: btusb: Fix enable failure for a CSR BT
 dongle
Content-Language: en-US
To:     Zijun Hu <quic_zijuhu@quicinc.com>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        luiz.von.dentz@intel.com, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        Zijun Hu <zijuhu@qti.qualcomm.com>
References: <1666868760-4680-1-git-send-email-quic_zijuhu@quicinc.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <1666868760-4680-1-git-send-email-quic_zijuhu@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Zijun,


Thank you for the patch.


Am 27.10.22 um 13:06 schrieb Zijun Hu:
> From: Zijun Hu <zijuhu@qti.qualcomm.com>

I‘d be more specific in the summary/title. Maybe:

Correct quirk check to include BT 4.0

> A CSR BT dongle fails to be enabled bcz it is not detected as fake

I’d write *because*.

> rightly, fixed by correcting fake detection condition.
> 
> below btmon error log says HCI_QUIRK_BROKEN_FILTER_CLEAR_ALL is not set.
> 
> < HCI Command: Set Event Filter (0x03|0x0005) plen 1        #23 [hci0]
>          Type: Clear All Filters (0x00)
>> HCI Event: Command Complete (0x0e) plen 4                 #24 [hci0]
>        Set Event Filter (0x03|0x0005) ncmd 1
>          Status: Invalid HCI Command Parameters (0x12)
> 
> the quirk is not set bcz current fake detection does not mark the dongle
> as fake with below version info.
> 
> < HCI Command: Read Local Version In.. (0x04|0x0001) plen 0  #1 [hci0]
>> HCI Event: Command Complete (0x0e) plen 12                 #2 [hci0]
>        Read Local Version Information (0x04|0x0001) ncmd 1
>          Status: Success (0x00)
>          HCI version: Bluetooth 4.0 (0x06) - Revision 12576 (0x3120)
>          LMP version: Bluetooth 4.0 (0x06) - Subversion 8891 (0x22bb)
>          Manufacturer: Cambridge Silicon Radio (10)
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=60824
> Signed-off-by: Zijun Hu <zijuhu@qti.qualcomm.com>

Please add a Fixes: tag.


Kind regards,

Paul


> ---
>   drivers/bluetooth/btusb.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
> index 420be2ee2acf..727469d073f9 100644
> --- a/drivers/bluetooth/btusb.c
> +++ b/drivers/bluetooth/btusb.c
> @@ -2155,7 +2155,7 @@ static int btusb_setup_csr(struct hci_dev *hdev)
>   		is_fake = true;
>   
>   	else if (le16_to_cpu(rp->lmp_subver) <= 0x22bb &&
> -		 le16_to_cpu(rp->hci_ver) > BLUETOOTH_VER_4_0)
> +		 le16_to_cpu(rp->hci_ver) >= BLUETOOTH_VER_4_0)
>   		is_fake = true;
>   
>   	/* Other clones which beat all the above checks */
