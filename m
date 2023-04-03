Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 716C06D4166
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 11:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbjDCJ5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 05:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbjDCJ5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 05:57:01 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2099.outbound.protection.outlook.com [40.107.223.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE0916A76;
        Mon,  3 Apr 2023 02:56:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BNRtdIHL2tt/wrgkyQVpXp857+bACeYOLAAraEJ3IdrC7rai5skRVF0wuyNfiecTU7RQKCseMoOconaFK55ncefYDOgZtRaeTjkzAOfeKGRymZG4mVCN7tOB54EbkrI09phO7PJb2mr2emS8vhGXPPp7MsUtl5HHNe+Rdevpn7gBppa8Ruu7wQhg0XPgj2vK78TUMR60yXdaVuXzGEAmOYgpkPsyetJ5t5wXBWsFloy9EMs5ocr7013a1+IbSczEDp3KY8HjkvWpVF9w+AacrPUzMY+SsheDmrvKTTz1QN6Z/5shomx/EWofd/Cnpfc582rC0e2Yz1VECAA1TqOlsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5F7DgsuRfmLt20e8z0UD77HwvUdxFQxQ166dL+KN7cc=;
 b=d8BP0StcWj+LrhROSYbuXcX3pNbmltZ7Pvkej4Lsbj6fRsiPIqUX8DxOnqHjrxER+wtYZEUdf9CQ1w+fqnk3PE3ujb9OShB/H6CWF7440fggWmeG90bN4Nj/mbLA9UHPuBN1XAevD4THM+0Q9Jz58wWfT6SN07rvPCV6W9cIGdfuMyvtqyvNsADABAuSJTF/wQgwr3YyY1oqqTX3Pjc5Dikj8+o0QE6C6BR5b4DmwhqXVrfSJbzgX4k+N/wTdCDmjwByjUyulgPRRTKStmmuebAN2LpAuNXwqLsp9NyzZqlY5xSEwwEIQfiK4Hwt9BEd9NalVFtDloc/iFrvM3cLKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5F7DgsuRfmLt20e8z0UD77HwvUdxFQxQ166dL+KN7cc=;
 b=oGRPDZbLv3R2TGPD2TvB2cfPs6vuTMa9xbwQSBqgvW2iv8RzGSMyiQfgUth7npromJka1oGh6d+EfBMrJdTld2MO5RcUMGHogw3ZPfC4SdAfs00Io6ONmSEUPvhYiSewHKOXJ/ZRahCRCUiWXE1H/Wnlw7uecBM52euUQwz5Meg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB4603.namprd13.prod.outlook.com (2603:10b6:610:c3::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.28; Mon, 3 Apr
 2023 09:56:57 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.030; Mon, 3 Apr 2023
 09:56:57 +0000
Date:   Mon, 3 Apr 2023 11:56:50 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     michenyuan <michenyuan@huawei.com>
Cc:     "isdn@linux-pingi.de" <isdn@linux-pingi.de>,
        "marcel@holtmann.org" <marcel@holtmann.org>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "luiz.dentz@gmail.com" <luiz.dentz@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cmtp: fix argument error
Message-ID: <ZCqi4laBvhCLrPhS@corigine.com>
References: <9b58282ff4ed4d2daad72539466c685d@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b58282ff4ed4d2daad72539466c685d@huawei.com>
X-ClientProxiedBy: AM0PR10CA0114.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::31) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB4603:EE_
X-MS-Office365-Filtering-Correlation-Id: bc2f320b-4c39-4548-a4af-08db3429c30e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: er8xNb7XisAdXrc22t5MrqZ/tGUGwSPsBOsx8cGEdLscU4srZy+lg55lmNCn6Dh1x43SfsrXaywKOWRPdykj4xrqtyk5i2df+CRNMOvM89ZLXggiwcbiqrjlrDUmAUYmWi7YvnxyhXuq0xvtlcgXJ6NlwPMuWWq3xVynTr/PRcJ0/rKCUpSSNpEG+K7Nz+itXn/o0sIWSkkWtTvscsDmlkVszxWRZMumuVH2X2EaN5/7j1zLg4KG3sf6wQIz1JBb043Zsv54KkZ1GWAdzIfBZZSKdBsoOFjfnWmfbGcl/anxosxYr85dZIze9oqZIegBT1gQEKiReV9xvKo4TwzNp1rLA6lWpoFCeC73cTCMt1s78xkHLOl9hE4PufqcyscCY4BJQYLcv6lRSmDKKWo7A6q9c5mrVvVKGPMieVHsFtiHWTeRn0G9xX+iDzCbNKAQsTiDHQPLmwQ7YkEhSSY/7CNa2xutmlbSpqMG66gxJig7OzN4f6y6mqc55CbZGSBQmhoCzPJvtCpzMYa3+e/19i2otq0wYFzlLvKknf2yfrixbykVfJyZ8LTuowVT12LnNdsh2yXU3Y+H34jXeSD3nRyDv5K/kGpO5A6cYBrUmSA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(39840400004)(376002)(396003)(346002)(451199021)(2616005)(83380400001)(6666004)(6486002)(316002)(186003)(478600001)(6512007)(6506007)(2906002)(54906003)(5660300002)(7416002)(44832011)(36756003)(38100700002)(66556008)(86362001)(6916009)(4326008)(66476007)(41300700001)(8936002)(66946007)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BRmPKm0Tuo4ZSqPuXmgQoPpj+A4mcYRR4Ef9LH98vJH/osFnvFINqHIgF24T?=
 =?us-ascii?Q?zcQu2EKg+PIhLms/eFa9FeNI8kpIsc1z/K7tWbnlYuxLvpzjE2hYkIhSy8N4?=
 =?us-ascii?Q?WdKNWH9pTNHPrggiQLqLDDGC2e317ZGK/0N9f95WJ5HxUPrDTfGRYPwHI4yI?=
 =?us-ascii?Q?fk+PmCcDKcOfAVUDxMi+glK3Nv3lmxewAqwhAvxXe/Y1ldzwpZpxwx3Lgg38?=
 =?us-ascii?Q?VK7vQa8Wzykegup/mHlbudK5nUUgkHWpUmEGKMIC4Bo1CfTW19qr99sC5Oor?=
 =?us-ascii?Q?/gSSITOnJvAvQ5cThu7HzlkOUGAUSdB6oIKCJQ5QKDKK3imGOLZ253ckZC5W?=
 =?us-ascii?Q?N2Ru4s703LpCsTxIBrRyZNDHEmGwd/Ei2bpyTJaJVtUpGRge87Py7n5IrvV/?=
 =?us-ascii?Q?fJuYltWNY99r/C3zGRMlRFB6g6LFOnhIrBzGjniz1LsSj/K4DpDEYPve+Lys?=
 =?us-ascii?Q?Zrcrq08FKEeKTR7jtjG5qPX3Kj66MEe//ddVY3sSJ6pP9EmKz0DuyvVxI58s?=
 =?us-ascii?Q?y8JSvxko4w2+YcryEHV4LSo2VsMqYyKnyWitUVlCkGSLVj1eBs5hFuAq2fmJ?=
 =?us-ascii?Q?HcohfaZr9u33LPFEt7Gl9ncGyCOyLmWYvECkSZbYFvr7zIRKnHAJsUKae0/v?=
 =?us-ascii?Q?TkJ+c51zgDorBaxhXnED7yH94GfcLEhpcebcxxLFMEUr/DVkXaX79Wa4Eh+m?=
 =?us-ascii?Q?iDjwM324MjJW0ACMU/2V4SWCz5p+9unFSnCbwgjBSSG40d1Ec2vZm3HFGFqW?=
 =?us-ascii?Q?pDMgfVwBvJUUG2tLhqjyHAMYTUN8O1LjHcNbVWb72Ubj+9XnfxFz8owGbr7I?=
 =?us-ascii?Q?NZ+OSahmAF308c43x13qLT/98GGo6NPV/FzLc+mgwVOqBpCtw2sbz3uCcoWP?=
 =?us-ascii?Q?pVogM/wPKh7KaTDT+ExlasaaDO7f16IWBLMrJqUWsIxU/g7EL1ErkwOMxdFA?=
 =?us-ascii?Q?yXEAMb8nV90/x4h4+bC7o6HhJi+7Qrt6mMeAEjC08WAWvCTtCOl01WB2sIx4?=
 =?us-ascii?Q?nh7a86nOjoE+hmKHfFsBDxgq4w6pPm/fE9eW61/5ieniXFpylrvtKbbyZpBE?=
 =?us-ascii?Q?YlwCsR7vlBRXVx4BH0D2WxP+aBVzETbheqmYJ242V68gxTD7ccHCHUIMLkHQ?=
 =?us-ascii?Q?s0XtdrEonRmKRrADyGTXxhaV9LF5zVO2l+hJIzF2Ps2Wt52EvAHQ+Upw4lU6?=
 =?us-ascii?Q?bq/ZiADbt+GqXH0lj0SG0JkbjFuT/wRtvAMpWdlrBLRCpNEU3e0SoCG66H20?=
 =?us-ascii?Q?Gk/Zgj/myd5sS+AAeM6cKgv6aUQvdwxrfYDiDKvntuz3rOqvcWAXCm+qIRZ2?=
 =?us-ascii?Q?JoyEODckt3JYL3e9sBV3DMgMEtsvakRDLcF1pWoV7srAehPnE2XswIMhi/iD?=
 =?us-ascii?Q?6xV6NdEmwyisTxA5JtDTo1MGlZSAL8mhyWVDU1TiHLBbp4oxRgy5zke27wDS?=
 =?us-ascii?Q?ItV1B4R8eHS7mx/6gOB7Jq2vf/bhTZjg8Wi86p81Mp7hT1Dn30zf1+btMz54?=
 =?us-ascii?Q?zj2bjuKaqq6ccl6pGcmTlWKzXMBBiOmYqSMcohV7w9/0kPBbBbZc5AsCDzV5?=
 =?us-ascii?Q?v2dT2o78MHpub1OCuAQPZlcNuuCsc7p4jDtNborR3QGMY3UTp8gjF7LnF3SR?=
 =?us-ascii?Q?LloJ94DFZOBv17pJzx3zj6EmVbOVe5adJVfDnL5RGS8FnWfx3IiKb7NwMG/4?=
 =?us-ascii?Q?7oHaTg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc2f320b-4c39-4548-a4af-08db3429c30e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 09:56:57.6076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y+N2vxnK0f2mzZ3YhNNV9bmYih6raQ80IceRivr+++KY6U4IGamd2iWjeUuD9tIpkNJ2kiBpCViYCFRP2j5mpHnW/C4zdQF0oa6ls4g5BCQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB4603
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 02:35:21AM +0000, michenyuan wrote:
> Thank you for your suggestion.
> 
> This bug may not cause serious security problem. Function 'bt_sock_unregister' takes its parameter as an index and nulls the corresponding element of 'bt_proto' which is an array of pointers. When 'bt_proto' dereferences each element, it would check whether the element is empty or not. Therefore, the problem of null pointer deference does not occur.
> 
> This bug is observed by manually code review.

Thanks, could I suggest that you post a v2 that looks a bit like this:

Subject: Re: [PATCH v2 net-next] bluetooth: unregister correct BTPROTO for CMTP

On error unregister BTPROTO_CMTP to match the registration earlier
in the same code-path. Without this change BTPROTO_HIDP is incorrectly
unregistered.

This bug does not appear to cause serious security problem.

The function 'bt_sock_unregister' takes its parameter as an index and NULLs
the corresponding element of 'bt_proto' which is an array of pointers. When
'bt_proto' dereferences each element, it would check whether the element is
empty or not. Therefore, the problem of null pointer deference does not
occur.

Found by inspection.

Fixes: 8c8de589cedd ("Bluetooth: Added /proc/net/cmtp via bt_procfs_init()")
Signed-off-by: ...

...

> > ---
> >  net/bluetooth/cmtp/sock.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Code change looks good.
> 
> > diff --git a/net/bluetooth/cmtp/sock.c b/net/bluetooth/cmtp/sock.c 
> > index 96d49d9fae96..cf4370055ce2 100644
> > --- a/net/bluetooth/cmtp/sock.c
> > +++ b/net/bluetooth/cmtp/sock.c
> > @@ -250,7 +250,7 @@ int cmtp_init_sockets(void)
> >  	err = bt_procfs_init(&init_net, "cmtp", &cmtp_sk_list, NULL);
> >  	if (err < 0) {
> >  		BT_ERR("Failed to create CMTP proc file");
> > -		bt_sock_unregister(BTPROTO_HIDP);
> > +		bt_sock_unregister(BTPROTO_CMTP);
> >  		goto error;
> >  	}
> >  
> > --
> > 2.25.1
