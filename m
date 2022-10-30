Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E96936129C7
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 11:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiJ3KAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 06:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiJ3KAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 06:00:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 878CFC77A
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 02:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667123964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lperXuLkSOUMuSlgJ3I7ALgwdptxb42WxxooK0bP59s=;
        b=RugE12po8nPLb7LrKrylU8ffHlbSwA7ogY8eNHYkO3R826SKpYNRDSatAemKRzp/zEx5mf
        VyxJMPXcnIEMKdLuy9hENn6K5DbWVI05eWwBvSTEphYbdxEmDLen2hE20GCnzae1Z2d6xD
        CoFcmqw8uonw8T3oSSIqYdqHyJRFSLQ=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-396-t1c2feSXMXC_b1P0hS6rnQ-1; Sun, 30 Oct 2022 05:59:21 -0400
X-MC-Unique: t1c2feSXMXC_b1P0hS6rnQ-1
Received: by mail-ej1-f69.google.com with SMTP id ho8-20020a1709070e8800b0078db5e53032so4526490ejc.9
        for <netdev@vger.kernel.org>; Sun, 30 Oct 2022 02:59:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lperXuLkSOUMuSlgJ3I7ALgwdptxb42WxxooK0bP59s=;
        b=3SskIRCw5xJAW+14Q+E2iRZWci2AxJk+CPS+Pl1WlWhnb1MZ1JDfTdeR8D6uUezbn6
         UsaaLnl8VDQFb7PELmpEPaeuaZU8FDM/iPpRabwlYkxI9yxKO14u3fWIKT8mTaDVw01U
         AvwYIeYF7okJrI2BePQiwrDt3afz+fwSPLzU7H4/YHCJwWQDdqdBYWBNoAg1ItjOkmNT
         vbk+AqcuPNjDphMR7uV17b+iN62bpxHi5xNMrQxyd+kLv5AZghWQvpef4nmEUuJm/MD9
         GBlPGXy1aCI4uJjNb5qN9a17MyxQ8hizJunUUstgftgEDzsvWf1F4R5JmqwTTs1UlI50
         HQXg==
X-Gm-Message-State: ACrzQf1+mDKwDot9us2fyB0I5w4pHtWZklFsXljfYcCOMRKxAO9wLTPM
        2JdcJUKT6/gVuRCm6ZKIrAWG7Ifao942bq/O/mikssmJyVnXlFbaINbmPO3oOmbbjDt2vwjI5xu
        NVJFIVhWP6Zc+8gHf
X-Received: by 2002:a17:907:2c74:b0:7a1:d333:f214 with SMTP id ib20-20020a1709072c7400b007a1d333f214mr7732268ejc.14.1667123960856;
        Sun, 30 Oct 2022 02:59:20 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5z9O9q09jz3IsSKd4hMBEsZJIqduETwCbwkmeHNeUBBPFIL1FFy/xhHwXrQ5bCCjaIPnQ2/A==
X-Received: by 2002:a17:907:2c74:b0:7a1:d333:f214 with SMTP id ib20-20020a1709072c7400b007a1d333f214mr7732248ejc.14.1667123960618;
        Sun, 30 Oct 2022 02:59:20 -0700 (PDT)
Received: from ?IPV6:2001:1c00:c1e:bf00:d69d:5353:dba5:ee81? (2001-1c00-0c1e-bf00-d69d-5353-dba5-ee81.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:d69d:5353:dba5:ee81])
        by smtp.gmail.com with ESMTPSA id co6-20020a0564020c0600b00459e3a3f3ddsm1879270edb.79.2022.10.30.02.59.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 Oct 2022 02:59:19 -0700 (PDT)
Message-ID: <0574f6d2-51dd-4962-40fe-9424a19cb3c7@redhat.com>
Date:   Sun, 30 Oct 2022 10:59:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH 1/3] Bluetooth: btusb: Fix Chinese CSR dongles again by
 re-adding ERR_DATA_REPORTING quirk
To:     Ismael Ferreras Morezuelas <swyterzone@gmail.com>,
        marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        luiz.von.dentz@intel.com, quic_zijuhu@quicinc.com
Cc:     linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
References: <20221029202454.25651-1-swyterzone@gmail.com>
Content-Language: en-US, nl
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20221029202454.25651-1-swyterzone@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ismael,

On 10/29/22 22:24, Ismael Ferreras Morezuelas wrote:
> A patch series by a Qualcomm engineer essentially removed my
> quirk/workaround because they thought it was unnecessary.
> 
> It wasn't, and it broke everything again:
> 
> https://patchwork.kernel.org/project/netdevbpf/list/?series=661703&archive=both&state=*
> 
> He argues that the quirk is not necessary because the code should check if the dongle
> says if it's supported or not. The problem is that for these Chinese CSR
> clones they say that it would work, but it's a lie. Take a look:
> 
> = New Index: 00:00:00:00:00:00 (Primary,USB,hci0)                              [hci0] 11.272194
> = Open Index: 00:00:00:00:00:00                                                [hci0] 11.272384
> < HCI Command: Read Local Version Information (0x04|0x0001) plen 0          #1 [hci0] 11.272400
>> HCI Event: Command Complete (0x0e) plen 12                                #2
>> [hci0] 11.276039
>       Read Local Version Information (0x04|0x0001) ncmd 1
>         Status: Success (0x00)
>         HCI version: Bluetooth 5.0 (0x09) - Revision 2064 (0x0810)
>         LMP version: Bluetooth 5.0 (0x09) - Subversion 8978 (0x2312)
>         Manufacturer: Cambridge Silicon Radio (10)
> ...
> < HCI Command: Read Local Supported Features (0x04|0x0003) plen 0           #5 [hci0] 11.648370
>> HCI Event: Command Complete (0x0e) plen 68                               #12
>> [hci0] 11.668030
>       Read Local Supported Commands (0x04|0x0002) ncmd 1
>         Status: Success (0x00)
>         Commands: 163 entries
>           ...
>           Read Default Erroneous Data Reporting (Octet 18 - Bit 2)
>           Write Default Erroneous Data Reporting (Octet 18 - Bit 3)
>           ...
> ...
> < HCI Command: Read Default Erroneous Data Reporting (0x03|0x005a) plen 0  #47 [hci0] 11.748352
> = Close Index: 00:1A:7D:DA:71:XX                                               [hci0] 13.776824
> 
> So bring it back wholesale.
> 
> Fixes: 63b1a7dd3 (Bluetooth: hci_sync: Remove HCI_QUIRK_BROKEN_ERR_DATA_REPORTING)
> Fixes: e168f69008 (Bluetooth: btusb: Remove HCI_QUIRK_BROKEN_ERR_DATA_REPORTING for fake CSR)
> Fixes: 766ae2422b (Bluetooth: hci_sync: Check LMP feature bit instead of quirk)
> 
> Cc: stable@vger.kernel.org
> Cc: Zijun Hu <quic_zijuhu@quicinc.com>
> Cc: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
> Cc: Hans de Goede <hdegoede@redhat.com>
> Tested-by: Ismael Ferreras Morezuelas <swyterzone@gmail.com>
> Signed-off-by: Ismael Ferreras Morezuelas <swyterzone@gmail.com>

Thank you very much for your continued work on making these
clones work with Linux!

The entire series looks good to me:

Reviewed-by: Hans de Goede <hdegoede@redhat.com>

for the series.

Regards,

Hans


> ---
>  drivers/bluetooth/btusb.c   |  1 +
>  include/net/bluetooth/hci.h | 11 +++++++++++
>  net/bluetooth/hci_sync.c    |  9 +++++++--
>  3 files changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
> index 3b269060e91f..1360b2163ec5 100644
> --- a/drivers/bluetooth/btusb.c
> +++ b/drivers/bluetooth/btusb.c
> @@ -2174,6 +2174,7 @@ static int btusb_setup_csr(struct hci_dev *hdev)
>  		 * without these the controller will lock up.
>  		 */
>  		set_bit(HCI_QUIRK_BROKEN_STORED_LINK_KEY, &hdev->quirks);
> +		set_bit(HCI_QUIRK_BROKEN_ERR_DATA_REPORTING, &hdev->quirks);
>  		set_bit(HCI_QUIRK_BROKEN_FILTER_CLEAR_ALL, &hdev->quirks);
>  		set_bit(HCI_QUIRK_NO_SUSPEND_NOTIFIER, &hdev->quirks);
>  
> diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
> index e004ba04a9ae..0fe789f6a653 100644
> --- a/include/net/bluetooth/hci.h
> +++ b/include/net/bluetooth/hci.h
> @@ -228,6 +228,17 @@ enum {
>  	 */
>  	HCI_QUIRK_VALID_LE_STATES,
>  
> +	/* When this quirk is set, then erroneous data reporting
> +	 * is ignored. This is mainly due to the fact that the HCI
> +	 * Read Default Erroneous Data Reporting command is advertised,
> +	 * but not supported; these controllers often reply with unknown
> +	 * command and tend to lock up randomly. Needing a hard reset.
> +	 *
> +	 * This quirk can be set before hci_register_dev is called or
> +	 * during the hdev->setup vendor callback.
> +	 */
> +	HCI_QUIRK_BROKEN_ERR_DATA_REPORTING,
> +
>  	/*
>  	 * When this quirk is set, then the hci_suspend_notifier is not
>  	 * registered. This is intended for devices which drop completely
> diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
> index bd9eb713b26b..0a7abc817f10 100644
> --- a/net/bluetooth/hci_sync.c
> +++ b/net/bluetooth/hci_sync.c
> @@ -3798,7 +3798,8 @@ static int hci_read_page_scan_activity_sync(struct hci_dev *hdev)
>  static int hci_read_def_err_data_reporting_sync(struct hci_dev *hdev)
>  {
>  	if (!(hdev->commands[18] & 0x04) ||
> -	    !(hdev->features[0][6] & LMP_ERR_DATA_REPORTING))
> +	    !(hdev->features[0][6] & LMP_ERR_DATA_REPORTING) ||
> +	    test_bit(HCI_QUIRK_BROKEN_ERR_DATA_REPORTING, &hdev->quirks))
>  		return 0;
>  
>  	return __hci_cmd_sync_status(hdev, HCI_OP_READ_DEF_ERR_DATA_REPORTING,
> @@ -4316,7 +4317,8 @@ static int hci_set_err_data_report_sync(struct hci_dev *hdev)
>  	bool enabled = hci_dev_test_flag(hdev, HCI_WIDEBAND_SPEECH_ENABLED);
>  
>  	if (!(hdev->commands[18] & 0x08) ||
> -	    !(hdev->features[0][6] & LMP_ERR_DATA_REPORTING))
> +	    !(hdev->features[0][6] & LMP_ERR_DATA_REPORTING) ||
> +	    test_bit(HCI_QUIRK_BROKEN_ERR_DATA_REPORTING, &hdev->quirks))
>  		return 0;
>  
>  	if (enabled == hdev->err_data_reporting)
> @@ -4475,6 +4477,9 @@ static const struct {
>  	HCI_QUIRK_BROKEN(STORED_LINK_KEY,
>  			 "HCI Delete Stored Link Key command is advertised, "
>  			 "but not supported."),
> +	HCI_QUIRK_BROKEN(ERR_DATA_REPORTING,
> +			 "HCI Read Default Erroneous Data Reporting command is "
> +			 "advertised, but not supported."),
>  	HCI_QUIRK_BROKEN(READ_TRANSMIT_POWER,
>  			 "HCI Read Transmit Power Level command is advertised, "
>  			 "but not supported."),

