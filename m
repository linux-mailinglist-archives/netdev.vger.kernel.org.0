Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47A6569314B
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 14:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjBKNpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 08:45:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBKNph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 08:45:37 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2093.outbound.protection.outlook.com [40.107.223.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14BE526848;
        Sat, 11 Feb 2023 05:45:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NJHKuVM2b30TnmsLAfESPN+OAMkWjKoumJpQjPRsurnYpZpFxSDEtbL/AOaNJwjAhupDKsy7oifMi2ETaZxdsXHL3Wfc38jSKRQdC6mE31p+c424K4sWdXnJaVLZgUAYwi+TFsoAMw+H7F8xAtT8dJraX6s1kjOoHfqr/0dqifqzuD5uBQlHioeDL/q9Os/tH9cbPujrcDb70Kb65zrzHKBVuA8Paqr0e5HTFUMyXo8QOhweTIXOhin81E1y/UsE3EsPsitxdIxQBXqCAmuzKJVVh40ni8MWSWv0lbtaMpk18aqsVHNLg6IHla+BamaQY59eFVt0MEdgJDTN/PcDrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SSKgPCWSlMwpF4PaXKxZM2+LDvaxuULkQV0+cuv1eHY=;
 b=WbCJEE1GjKP5L2QUhb1+8TFFZSxPD8qdGE53xRgTit60oXqCkR1wmHpljmDIA/WGtNSXiVYqUBbdu0gRGuqS8/0hZn2i/DAEb2HLAnTix6k66FYwvVA13+kOd8i0ukX/9XTvy/dJa17Y8X6HLH6NKZT9jdYx4OKNgE48fPyOEYHmdHHUkIzuEhyc00gdS/24Aj+BxgpJffAc+wngP3eLNPlJXr9HQGcxgsBJYZcYZHHaXAv15He1aSOTF2p2q4oZ8KFzCDjNMYPB4Re7M39/mX/nex2B2Ap89KHspbuvkL5fGO16WSBH0jT8y8CAU9sv9FpI9illQUQ4Kp5jKWkzsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SSKgPCWSlMwpF4PaXKxZM2+LDvaxuULkQV0+cuv1eHY=;
 b=XGK9vMFRz0S87KlF3dsoK5O3Zrlg7/eHWpW/ir9tJ/m0ANqyAom7Mua44g+1DKv1g8/DIpx8CKxe86Jmxq8aldvn8n35lz9n0E63Wb2riinS9KGQ2uGomwO8Ng0uk2RGYlugbO1vOnrRHMKhjJPBLFpDbw7tOvrJdReBc+pECu0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB6035.namprd13.prod.outlook.com (2603:10b6:806:20e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.21; Sat, 11 Feb
 2023 13:45:34 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%9]) with mapi id 15.20.6086.022; Sat, 11 Feb 2023
 13:45:34 +0000
Date:   Sat, 11 Feb 2023 14:45:26 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Natalia Petrova <n.petrova@fintech.ru>
Cc:     Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH] b43legacy: Add checking for null for
 ssb_get_devtypedata(dev)
Message-ID: <Y+eb9mZntfe6rO3v@corigine.com>
References: <20230210111228.370513-1-n.petrova@fintech.ru>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210111228.370513-1-n.petrova@fintech.ru>
X-ClientProxiedBy: AM0PR07CA0034.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::47) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB6035:EE_
X-MS-Office365-Filtering-Correlation-Id: b8f17f34-b8a8-464a-9fb0-08db0c363f49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uXK5PS9XXKgd9QdSdtRoLIIAar+rjCOcyRc9d2m9DUpZyCfr58ktc90vuEbQ3rNkFRd5gF5I+mZm84fEclihN95cEB6P6QbPEl8TBSnl1SpyaERsZvvczHyajRak/bg5GZXaM9UkTgOFupRBr1HKdzRfsfEzirAelyGRKYz4IBdfLzc3S0qN8b/3Ao+0bHysN/chzRSoCPHGscEoR8uypDXGklXWIBdGAEfdGeMZh6Sr9zZFzvwYJ8aqmPpcws9oB7A3LMWCFgoYwiP77M9tRTOTKIaMxxBGFdAhxFJ0uazuTcyWTAxI8zWTJ6tw3QafM07LqkJ6VfRp5GdYtuZ4OnVN45se/2AlSWHiFamluRVht0RfkT9BMKErLMEcHV/qJj2+YZNE4YlO7hffkixqUar8+nPXEp9iqryOo30k4gq7zOlvQpNmM9Ato5vNo0EOxOQyCQlFtG3cZnNC+lTCkt509/k3+CaC17rf0Vz09MEs8c9xA/LQN+Ttgw0iasob4uMHuRDllJOIK6vfoCHq5KXRyT1qnZIW9AjouI01ex8bsFNP3jTYsOqG9avl2t9s2Onf7UR08+z0ATOeXHnlApjNNZWY2t8VhP5dD9iiAgHN39RaGEfnsBe+KuOX8QTV7NZLR5J4NTHAReKPKMOwxHZAl/iUBcvLr1PrqFu9wJXf8Vsa6cL757SIUUImLhbn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(346002)(376002)(39830400003)(396003)(451199018)(44832011)(6506007)(186003)(5660300002)(7416002)(8936002)(83380400001)(36756003)(86362001)(38100700002)(6512007)(2616005)(2906002)(316002)(54906003)(6486002)(478600001)(6666004)(41300700001)(4326008)(66476007)(6916009)(66946007)(66556008)(8676002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G4Yu/55s7kfOY5rJjwSVQFnZLq/I3ag7GwGigxzZh/qywy6VGQvDWn5EKMA/?=
 =?us-ascii?Q?ozbqqIwJfTuXLc/kXeoLP3g5czWnEOfgItmWo3G+h+8l0Vwoo1eP3X4RJErv?=
 =?us-ascii?Q?eO0A8ACLf02pFiDJwj+h6N1veH7zT+9Vz26JGfzt06+ugosw8C0an1YF/WDh?=
 =?us-ascii?Q?45lT/X0R/bBOBPooZ9WGHawS39dJYT4a8JaAUTNTtQD43aTaRV/b3jnlbg0H?=
 =?us-ascii?Q?gswiirM/OWQLfV/yVdtKPF3KrgS96h1edhKPIDMzwnvq5g089uhN/u99SPTb?=
 =?us-ascii?Q?1q6B7AWDJonSUWZJ6NK2qPNl4G60fSF5QAMkCG3QM99ZbLbo/RnLS/qZXfFz?=
 =?us-ascii?Q?L4TEjROqLaNdZu4MFlNbQ/1szGpOCE1HQ2uQ8Lt7LYR7RjZ7PBBiUJDaS0QR?=
 =?us-ascii?Q?X763YLeegJbt/f7Mz9R5/didhOg3plVgKuIQBkV/rrmBXxjYD0pUv2sBD6t6?=
 =?us-ascii?Q?tAPEsWCmlDRmCuamSn7jI1XcZxJCYQllOF/AQj2E9W6mKmz2paYW4+QJajmx?=
 =?us-ascii?Q?JyHUgokQ1y+YY6c3F9wF49ZIoj0hDrGhEz6nVniaBi+rtiS/S1UoJCdPvLs7?=
 =?us-ascii?Q?wHCwLaMQ55kAvTafqCnClBQALruOEs18nMhSDRyeRalEgI0ZxjdzOcldAOcs?=
 =?us-ascii?Q?OVr1zbX1vP7CjSECVFaj8aAGFUXlziak8HrwYVetcKfujYfh4pWwiPAur3dg?=
 =?us-ascii?Q?H9WHDHyQz8zRH8R1lJnQxLmTqAC0hL/qLHE1hieUhEyjXN/KrvsSziUUq15H?=
 =?us-ascii?Q?B6ML/75zwLvxCWPkObg30S5zF8mreyde7GO5Z9ujnlLLQsct1xo9riezqI+q?=
 =?us-ascii?Q?Xh33ohIw+EPqJ1Yl+O8nBrRTSLx+N1x7wv1DfAOt1p4K+EgXfbECQ70C/0S2?=
 =?us-ascii?Q?CPXwnHry8KNMPfipM0xiFkM4o+5rjYxxmkIIF4pxGeAB5lf1bx3Sh4xOFVqr?=
 =?us-ascii?Q?19tgLKpzXVlgbsI9sHZZRKNve0/EgyiR2PD5uZtayZUJmckp5Zz/uKnbHaCI?=
 =?us-ascii?Q?Pijv6ZekNYHfSQCe45BtGfMqxIi3ehI5B++zGW+fXSfHJn5aISaJddCUnInv?=
 =?us-ascii?Q?El8vCynGKa4Zla8hT1ZO14a5NQi1AUNzAV+7qx+qSbxWBvNa5N3w6h388hNR?=
 =?us-ascii?Q?0/cZukd/yNq7lqLWBo4RMSEh1kfEDGlYqO09omlUprM2qs/+1zQTNkwIBTQX?=
 =?us-ascii?Q?TMzvL4wNtgnAca+j/n75xsJApFO0kjU6lYYwk66HF66v2vhkFWSR/cmbSZSL?=
 =?us-ascii?Q?vViNCmAK7gHVZ7J1qORl8M99SDD5/s0MdY/cvzXDvvOd3Q3TtGZhUJc005Ey?=
 =?us-ascii?Q?psSYNt6ndqpZoutgLVrMosBFffDXTGo7Zb3Vz45IgFtYp8ivWxnjc9R9aFcO?=
 =?us-ascii?Q?eztCr7CiTpJKD2q0SSgaSiidgAiI2/Nyp4HFbBDFZMwWiCNuDbkCu+8o5CEJ?=
 =?us-ascii?Q?hQmjhkZuiGwrs3efBfbMWHahq5yKU+k5cCydaMc8kJFM4tfoGwg6YYQRBkjN?=
 =?us-ascii?Q?aIuCspfP26buTJJ8fgTAkKhkmeBcKU8I8fchhr55NyuIIpHJimARW9KzhDL1?=
 =?us-ascii?Q?8jvX4HnG3S8eIikiuOq3di+Pn8Voop3vjF/CUyGg2jIWoIEjh8keFYMNGDAm?=
 =?us-ascii?Q?qYOn7VhW/DtB5SYccMw7tFwB9WUKYaPKNgN8r4VSk7lW02rcFka/DNk94qPl?=
 =?us-ascii?Q?QqecWw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8f17f34-b8a8-464a-9fb0-08db0c363f49
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2023 13:45:33.6988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cr+ECbMbcU1ptP4zj7vgC+WGTZcFBFLKtgyy08SwKHRIIKFXT3NXKoJSvrR050PSeTz+dm8mdTiPuNrsGpZcZgwHsK5ulrnvuEBKD0Pc1k4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB6035
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023 at 02:12:28PM +0300, Natalia Petrova wrote:
> Function ssb_get_devtypedata(dev) may return null (next call
> B43legacy_WARN_ON(!wl) is used for error handling, including null-value).
> Therefore, a check is added before calling b43legacy_wireless_exit(),
> where the argument containing this value is expected to be dereferenced.

I see that is true, however, in that case are resources leaked
due to the ieee80211_free_hw() call in b43legacy_wireless_exit()
not being made?

Moreover, aren't there also unguarded dereferences of wl:

1. In the call to b43legacy_one_core_attach(),
   which would branch to err_wireless_exit on failure.

2. In the call to schedule_work() just about the out: label.

For the record, and because it seems relevant to give contexxt,
b43legacy_probe() looks like this:

static int b43legacy_probe(struct ssb_device *dev,
                         const struct ssb_device_id *id)
{
        struct b43legacy_wl *wl;
        int err;
        int first = 0;

        wl = ssb_get_devtypedata(dev);
        if (!wl) {
                /* Probing the first core - setup common struct b43legacy_wl */
                first = 1;
                err = b43legacy_wireless_init(dev);
                if (err)
                        goto out;
                wl = ssb_get_devtypedata(dev);
                B43legacy_WARN_ON(!wl);
        }
        err = b43legacy_one_core_attach(dev, wl);
        if (err)
                goto err_wireless_exit;

        /* setup and start work to load firmware */
        INIT_WORK(&wl->firmware_load, b43legacy_request_firmware);
        schedule_work(&wl->firmware_load);

out:
        return err;

err_wireless_exit:
        if (first)
                b43legacy_wireless_exit(dev, wl);
        return err;
}


> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE
> 
> Fixes: 75388acd0cd8 ("[B43LEGACY]: add mac80211-based driver for legacy BCM43xx devices")
> Signed-off-by: Natalia Petrova <n.petrova@fintech.ru>
> ---
>  drivers/net/wireless/broadcom/b43legacy/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/broadcom/b43legacy/main.c b/drivers/net/wireless/broadcom/b43legacy/main.c
> index 760136638a95..1ae65679d704 100644
> --- a/drivers/net/wireless/broadcom/b43legacy/main.c
> +++ b/drivers/net/wireless/broadcom/b43legacy/main.c
> @@ -3871,7 +3871,7 @@ static int b43legacy_probe(struct ssb_device *dev,
>  	return err;
>  
>  err_wireless_exit:
> -	if (first)
> +	if (first && wl)
>  		b43legacy_wireless_exit(dev, wl);
>  	return err;
>  }
> -- 
> 2.34.1
> 
