Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 135266F316E
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 15:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbjEANLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 09:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjEANLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 09:11:44 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2091.outbound.protection.outlook.com [40.107.92.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 835BF138;
        Mon,  1 May 2023 06:11:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NvAs31/ADHG4jqyI1SpUp5Q12xBpFcPpUAanZqeXlMBKY6jdJSWFwxnkNz52jsngJJy7SdCp+ySu4NionX315h0fo/Vk8wIrQtXAurTkeda89oYrtNeNBd/XaujKcpHrgpLtTm2BgN1kRgWYgK8HLoUtlSMvV7q6s+u1QL8kdwrWipezThfvKk8lX1LZyYXRinOs43CaafDt0GLX9WNAThzGCZDqK/9fGy03bzFyNI5vRc2qAAs39gL5reUsBrRjGE9MbzhRhp8+f5YPMdRsNB+X6LPzoRpWMzhwrK1hfsbmS8fyFbUjP9VKm/1GNBiOqvM6x6SQPKMMHiK5Cl10mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F9EOB/+P3FThVnXLcFX0wPryfGtO7VdhsnZNIjCibgs=;
 b=fKgCBO0vix7skkwO6YcR6a++AgJYzZXENaWQDWsyWmgNUFPJIabob0LnXHyXwt0NBMnWbeu1LGfvdYt4h+OhdAa9umCVrmazB5Cirl9oFFv1aL/ugARyeUS6l58E9s4CbwbpMlDqpCnx+gQM8j581HA2dRqFpHtNKAs8YVqK0vLFuuTzs0kzqfB7H+wmmBMXFFkUi7b83WvP4CLk6YTcwDEl/NCn+b800tyAolhPuQ84HJU0dpOGEkLAHjn2ey8fJzGsZ/PgYEdOSS+bMwY1jAwP3Qacw0wrEeLw4yxZq3Yo+3bFQj+EzbPKzWp+Am6nU13LJ3tJw7i8cN7qlYaHZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F9EOB/+P3FThVnXLcFX0wPryfGtO7VdhsnZNIjCibgs=;
 b=FzGSbFxeup0hcKuq5p8ttJGoZId2vAvWkMYzecJX/fWzFUCJe2XUQ1M+oVGJTeEh8De9j7QWhOUJND8oHKarafK2Wroa8FFo/hNeaNf8vimm9820g5G82QIh7AFNZuymaby6oLwLs6Mcx70EoyKCEECdU8ISZn6g0RQT6KImpNE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB4037.namprd13.prod.outlook.com (2603:10b6:208:24f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Mon, 1 May
 2023 13:11:38 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.030; Mon, 1 May 2023
 13:11:37 +0000
Date:   Mon, 1 May 2023 15:11:23 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Luca Weiss <luca.weiss@fairphone.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Balakrishna Godavarthi <bgodavar@codeaurora.org>,
        Rocky Liao <rjliao@codeaurora.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH RFC 2/4] Bluetooth: btqca: Add WCN3988 support
Message-ID: <ZE+6e7ZxJ2s9DHI1@corigine.com>
References: <20230421-fp4-bluetooth-v1-0-0430e3a7e0a2@fairphone.com>
 <20230421-fp4-bluetooth-v1-2-0430e3a7e0a2@fairphone.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230421-fp4-bluetooth-v1-2-0430e3a7e0a2@fairphone.com>
X-ClientProxiedBy: AM8P189CA0013.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB4037:EE_
X-MS-Office365-Filtering-Correlation-Id: 87abadb9-c5cd-48fc-d899-08db4a459888
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eR57736ufEKg8hrWj57mg/vMfNi4IZjqk7hXd3iUNR33C/8Hkh2Cc7x/J/d1+ei70moCr9aAPFENzjXkouCQgb74eWDMBLMbyl0fiTqufvB1Fw0c44hIP4OOgUKB+Z8d5BZduN7lEsLPxEdsJsmz/ltW2Kqzt7oK4MnrK7DtHHEYn3jOra5AjoQSU728waVuOtj93bmQgrKFBm+w8xdTOjofg/xHJmaxPUqwrLrvTNQLbDsNUVadIfrkQxEPOySaWVtAil0EmYQ7T6iww01EkA9uLQMXFrEDrqFOIvEGLSANwEJd3Ak39YttliloDYLM6mGFt7XtgzIETrgQNOTyuIEhT60US6knm8TuR5EJ+SVNrdzG6W8aoJhzgrPWwJhsAIKAgHb0DnlN0SZ2yJoEG/hne2qlnwdEURtlJel9bW6UjN5CnxbTBXGqpHW2EAtNBS+NfQA6aCFs4Tj1prRmZ/tgJNnp3iSc1SaZDIQtjbJwPTl3+GJ8SflymYdQOH83RIc2q9Lh4i3lN9JZ868C4JcXCwRIO97hXjAkBU26G+RzAY3uDfVAuHvajoNV63BPOOa3GUeMKffbjFXcODazAsMYbIBSE9IwO1w0KizxcT91PxDo/A+X9TiTzhfSFsnuufE5hzY1OsuG6B+zr4JxXqwleJuk8lelIoDoKw6yXE1onylneU//8azzTWGbMcdv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39830400003)(366004)(376002)(346002)(136003)(451199021)(86362001)(36756003)(38100700002)(83380400001)(2616005)(186003)(6506007)(6512007)(6486002)(6666004)(478600001)(54906003)(66946007)(66476007)(66556008)(4326008)(41300700001)(8936002)(316002)(6916009)(8676002)(44832011)(5660300002)(7416002)(2906002)(87944012)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dVWX+xkK6PgLWmhZWRAgkrRzHao5iCMzHiIiwCE5QSpg025ACOAraQa9fxro?=
 =?us-ascii?Q?1RD3WuVktQOIzuycpqpFzWnF/leEFzPJ4s074pHSgFCWPPEuLPMWaNTJERRL?=
 =?us-ascii?Q?ZlnbTNOGGv+kqW4aIOH9Cq/1kKndoCkdLEYh7neBEnBtrblyfHDxXsONCb/+?=
 =?us-ascii?Q?4jMSl9u4HdJIWm+9A7xnDv3fjvwxFDD4dpcEPJQLVmxZ96iPgFWrDj9Z/Wpy?=
 =?us-ascii?Q?ui1G+PdQ8SyvHNbJqpALR+QHcsP59ALIHl6WADh4oTByknZrrXySsNZ1d7Ub?=
 =?us-ascii?Q?ge1oTVOsWjpGlOEjvF5I4ZTErihtuimSTiTaAejJP1jCK16MkIfo5tvEUbei?=
 =?us-ascii?Q?oxk62WmQjqmo7J7OI6Ut3u7Lnk8Yr2ZWRf0h04yS5R4m/vuDhK5aQqBZRCs5?=
 =?us-ascii?Q?lzZlVm1jIq54YUbB3bU6UhzBZ2VhkegJqmDH4zGSLx11lZ10goMyTkmmkn75?=
 =?us-ascii?Q?PphnRde4KYOwPr+CbyQyS6BGiL/2/Ovi+T/YtamB47GP5eHEdUjzMJrgjH5T?=
 =?us-ascii?Q?dRIJx5FaGCNq5zZSjiBFfR0Ua/51wMQt9L2aSYhnBDBnl3zgKLtIuQqbJFEl?=
 =?us-ascii?Q?oMEeXF+KVMitYCrpefg4vnORVSQ0oJHkPyVQr5XIygJiILDNFa+pYCgDrPXt?=
 =?us-ascii?Q?zV0K2O7LbA+NS4sgEDDI4ZiVzH5azSIP2ZejPKFduVKlUMsbZn18q84mIFkU?=
 =?us-ascii?Q?uL8F4aQwbeTdW1PYIPwJybGji92ttH8ID7kcNQmJI4d7zQETvHC+1UnHeowJ?=
 =?us-ascii?Q?ZTpry71mXKny3foEGNiAxVYebT8Uhw59o4MNC7xjI6BsWbIn/uzgTm35hxfG?=
 =?us-ascii?Q?iFzR5gqe8YgH/I1u4AA04zgKbPBdZTjstsCgyKWqwZ43VRMhhc4RkaBTiSz7?=
 =?us-ascii?Q?XcuJf1j4mKgikSEPEkwB/gh+CmPTfaEu+Bb9KNfJu3akwEW53UleO15HgPxs?=
 =?us-ascii?Q?BpHvCfPQtWDJEBuJ5Mdd6OKZVV/7VqcEiPsAwq7x3zaSz8MkNW/kuFfGVdkd?=
 =?us-ascii?Q?cT8o8GP2t14DEdAo3SeK9PjekkPqckKDfM9ge3+vUhJT7d/W0Nzb4h6SBgwG?=
 =?us-ascii?Q?l7YkMuTejWPyvBRN8/fAOEkCOakpsAKWjwM359kJzD2Z73NRPQLzIh8iuCYj?=
 =?us-ascii?Q?fRvD5lqvW1JCSuOCu6dx7ckuP4JXt6WnxuFOUTsWhcvm/amF1AzclqyI8Nql?=
 =?us-ascii?Q?OeMpy3cmEq0CkOwKvZRxiPVagpakEUGzVD/cD2EBevVhe9O97xiC9M1dyDoA?=
 =?us-ascii?Q?SQ14Wpst7md1qOBlAtG4SqWmoaYTW3ayPMkleoqSlvy+e48pxRB8rU+CbdkO?=
 =?us-ascii?Q?c/3HS/66aUfqZ3/6TbIK9Mp2MglfNCRP2ZMdr1USpINOG69KH5lC0sotzqqs?=
 =?us-ascii?Q?CW8phv+4UWp8d9VK4SdxXF6N5TD67x4yAS7m2eJB0VeKpeajrl1CpCQMRe/h?=
 =?us-ascii?Q?4F5z+udZXPhh7DH5BwUtReFjQQZMYArdSRULPoxC/hDKI2vqlaEka0kmooCP?=
 =?us-ascii?Q?UIaWod0ynkdpl6nPcllroh+VNwi0DSGLRTKKfBz0KYL2GYKEG5//yI5FuQ1S?=
 =?us-ascii?Q?RQS9WBV1xTW6b1geGt6Zoo1pigJsRz5qw+pC0/52Cfm4G0dwEMx/BTG7fmD7?=
 =?us-ascii?Q?YuJSloG58pblI+PaxllkbY+5/RGSCvTd7DPtLqH7gmqZ1r2FrboV8+CFGZfb?=
 =?us-ascii?Q?/Slrow=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87abadb9-c5cd-48fc-d899-08db4a459888
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2023 13:11:37.8601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9HfuUW+8GeopbISiXMl+n4qecJ3nn0uqN0tHECfRA+RYfLqhsnOEystULQZqpU5RLfq9mEqHlR73DXo5rQN4fy7oncV5jMPRegN9OX7Yceg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB4037
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 21, 2023 at 04:11:39PM +0200, Luca Weiss wrote:
> Add support for the Bluetooth chip codenamed APACHE which is part of
> WCN3988.
> 
> The firmware for this chip has a slightly different naming scheme
> compared to most others. For ROM Version 0x0200 we need to use
> apbtfw10.tlv + apnv10.bin and for ROM version 0x201 apbtfw11.tlv +
> apnv11.bin
> 
> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> ---
>  drivers/bluetooth/btqca.c   | 13 +++++++++++--
>  drivers/bluetooth/btqca.h   | 12 ++++++++++--
>  drivers/bluetooth/hci_qca.c | 12 ++++++++++++
>  3 files changed, 33 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/bluetooth/btqca.c b/drivers/bluetooth/btqca.c
> index fd0941fe8608..3ee1ef88a640 100644
> --- a/drivers/bluetooth/btqca.c
> +++ b/drivers/bluetooth/btqca.c
> @@ -594,14 +594,20 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
>  	/* Firmware files to download are based on ROM version.
>  	 * ROM version is derived from last two bytes of soc_ver.
>  	 */
> -	rom_ver = ((soc_ver & 0x00000f00) >> 0x04) | (soc_ver & 0x0000000f);
> +	if (soc_type == QCA_WCN3988)
> +		rom_ver = ((soc_ver & 0x00000f00) >> 0x05) | (soc_ver & 0x0000000f);
> +	else
> +		rom_ver = ((soc_ver & 0x00000f00) >> 0x04) | (soc_ver & 0x0000000f);

Hi Luca,

perhaps it's just me. But I was wondering if this can be improved on a little.

* Move the common portion outside of the conditional
* And also, I think it's normal to use decimal for shift values.

e.g.
	unsigned shift;
	...

	shift = soc_type == QCA_WCN3988 ? 5 : 4;
	rom_ver = ((soc_ver & 0x00000f00) >> shift) | (soc_ver & 0x0000000f);

Using some helpers such as GENMASK and FIELD_PREP might also be nice.

>  
>  	if (soc_type == QCA_WCN6750)
>  		qca_send_patch_config_cmd(hdev);
>  
>  	/* Download rampatch file */
>  	config.type = TLV_TYPE_PATCH;
> -	if (qca_is_wcn399x(soc_type)) {
> +	if (soc_type == QCA_WCN3988) {
> +		snprintf(config.fwname, sizeof(config.fwname),
> +			 "qca/apbtfw%02x.tlv", rom_ver);
> +	} else if (qca_is_wcn399x(soc_type)) {
>  		snprintf(config.fwname, sizeof(config.fwname),
>  			 "qca/crbtfw%02x.tlv", rom_ver);
>  	} else if (soc_type == QCA_QCA6390) {
> @@ -636,6 +642,9 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
>  	if (firmware_name)
>  		snprintf(config.fwname, sizeof(config.fwname),
>  			 "qca/%s", firmware_name);
> +	else if (soc_type == QCA_WCN3988)
> +		snprintf(config.fwname, sizeof(config.fwname),
> +			 "qca/apnv%02x.bin", rom_ver);
>  	else if (qca_is_wcn399x(soc_type)) {
>  		if (ver.soc_id == QCA_WCN3991_SOC_ID) {

Not strictly related to this patch, but while reviewing this I noticed that
ver.soc_id is __le32 but QCA_WCN3991_SOC_ID is in host byteorder.

Perhaps a cpu_to_le32() or le32_to_cpu() call is in order here?

>  			snprintf(config.fwname, sizeof(config.fwname),

...
