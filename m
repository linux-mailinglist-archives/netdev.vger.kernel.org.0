Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A89426B903B
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 11:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbjCNKgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 06:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbjCNKgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 06:36:08 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2070f.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::70f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E82998858;
        Tue, 14 Mar 2023 03:35:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JCXsenlYAwxW7ozCcKJH/z1270mOLIprRp4Vm/MzLzF5svW3aUVdvfxfkVRdm3Jhufy+3vWQEv+rY6cDTKZrfw6IsOR0Nyc6sqZ9UtE9Oz3TYwokdNnlEReZKK92yGUkYEFPlOfaAH388ulsoeA8fG+at5HBKnVNdGhlmC8LZMwZ+C3TeK7H1ZPNjZKogDjNBbQKtq3Gy9z0noNsLFs/L0fRilKbbMzDwy8JHoub3cNa/OVfhbzJgLRUpBaNfTAScToVxPsGPpsL/Eva4c2BTqLrXyOwSffhzyJ31RncG/sKsWoJCpQDNl3YGSWtU+AIiM3QugGiOBYuyZ2cpQx6yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Sct7H8VZBVAxA6FhIEWNFLZqstObyOjayFmTzocrz4=;
 b=Ef3W9e3z54pADnOnoYl4wMo0WU8I9S5zxJVvswKgphuF78qK6bT+OMrMpL9NYGCworasBHFoUcic6YqOjbeOL6oTmajvHv3AFckoqfHAwHg4SSH8sp8rGllbx7xvoZ0H1+xME+smqauJtzlCSSm0lecfFrg7YBZaUNFftvNHyWt6yv+h+EbpwRcRjDa8pmrD03nWjSP9XGMHWBTU48OUtAdi4q+4BvCseII054+OUutQgiGikGosYPBU9EW5juGkCUIeqViknGAac87Q0hkJBKW6rFDGYsxik17b0SwiaT9TKAA2/2+xzTGOyyX2GzQDQjxHuzikBBWalTWmW6ZCUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Sct7H8VZBVAxA6FhIEWNFLZqstObyOjayFmTzocrz4=;
 b=BAKmap6k06aeyFWCjr1YbWZDgvMq8WqMyI2uBu2zh1hskTs2G6MLh++JQHBHCeStvylE8HKGQOTg0ZYn36mshF7LisoVGOLwifcmWFtPVDh1DtCYzP055Cx1QadkwuxK+AxxnRHpk44RXGDrq7BziNvrzgU+xwmNxT3PgGcximU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5890.namprd13.prod.outlook.com (2603:10b6:510:159::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 10:35:16 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 10:35:16 +0000
Date:   Tue, 14 Mar 2023 11:35:07 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com, leon@kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-serial@vger.kernel.org, amitkumar.karwar@nxp.com,
        rohit.fule@nxp.com, sherry.sun@nxp.com
Subject: Re: [PATCH v10 1/3] serdev: Add method to assert break signal over
 tty UART port
Message-ID: <ZBBN2ySl/q7NGehB@corigine.com>
References: <20230313144028.3156825-1-neeraj.sanjaykale@nxp.com>
 <20230313144028.3156825-2-neeraj.sanjaykale@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230313144028.3156825-2-neeraj.sanjaykale@nxp.com>
X-ClientProxiedBy: AS4PR10CA0024.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB5890:EE_
X-MS-Office365-Filtering-Correlation-Id: fe447f54-e67d-4b01-fbf4-08db2477ccd5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ht1SgSwynMTxFiuFFwfw+ErYMw0WyHDuX4Ac7HiivxzTQp2ST3q5UrJFIYukNL3v5I2QdVZHqOvg3ds6UM9p3NL3n6srDUg/eTQ2qsokxRRdUmcBkYAs88Zz12XkKV4xYNDoDd9OSAJIElMbz77UbZrw57f51A8D2ie8vBn1m/RwUqYcSqWS+W2z4wGAHj4vBPCPwDmzjeVudgUzGoK9+M55IrbpvcYHN6dyWf9YJ1vuPmbKOa22pgIb9zzH5Sbr1q52G/fI0ER6TiZd8yeyuaVpoou5MVBIhpkMwOZ+lX9Svajgj2rdGDdo7HrIukjtWnqM+ByJmylCv/AuQpg7xWHG7uxaZosdp7UtJYkDfp1iqGFM/9EvVVguf9xyN2es1LcNIfmGAkWndXH3//QECCeGH05tnQmIXZRm/aVIoU2PfVhYtFeo/IOkchnIJ5l0Sv0NuJ0+pG/tgFlbFIKoSJwEdF6dgcbG2hSXNAtd28E1QsMuTI+zVP9z/Qm5VBTiJ03fGOgzu9QEAkSE66Rqfr2oCoE/P5NXOxQ1m+5Yyivud0x+0umrcFmN1ILFvEN+XS2jqlguYTFsEHv6DScvkPWylV0qC8IBLhxcCb880FF4g6lrZgwpKbiraXG68LS5mh62sEWLJ22enAfurRg+Kg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(396003)(366004)(346002)(39840400004)(451199018)(2906002)(83380400001)(36756003)(5660300002)(7416002)(44832011)(66556008)(66946007)(316002)(41300700001)(8936002)(8676002)(66476007)(6916009)(4326008)(38100700002)(86362001)(478600001)(186003)(2616005)(6666004)(6512007)(6486002)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tpvYrhqFVY/y7t/ah92X+iYvML9OeWf0l630pM7pWLCkguDbsdiKd3kQObYF?=
 =?us-ascii?Q?xBvDZEL8aMwsd3KQiYsjJWAcrTPQGJJCZZG6jOZ2O2YnvNn5fuJZwVhQhene?=
 =?us-ascii?Q?x/N/bjuoKq+WNIooJSB9z9BxZH+kxWHkyz5hqZqWHJlJb9vqblbXc/xz9D2f?=
 =?us-ascii?Q?rgX2VtcYZh9L5CnkHfTYc4tozBtwrmqRtnvhv+FEuenFR2Q2hh8s8QRVc7ow?=
 =?us-ascii?Q?JmVKzn+Bt/dJ2U0bAGLrbSDJF2uUJRpDqc1SD1akxPAA3S3JLDycO1pZuoTr?=
 =?us-ascii?Q?m9gbOqklwwNFLdh3Snz3rmvaixeXIHmORgtk7EZxLKIUzlzmayshlxTK1qx0?=
 =?us-ascii?Q?u+3AeiBYp8lmjb4PkYF6vGJnBESPwklFYcMsdUGJdg8NQ3KcFKpz0ZK3Ra5F?=
 =?us-ascii?Q?06L1DnyiTR7TatogChjarZL1eNqF2ucbF/myMP3zCtNWKgOqfXd6trRtDOVu?=
 =?us-ascii?Q?bvCKmlzh68bSZQsx8ZT0EQwTDCTlLSNV4arm9SlDiYz+lS26WYnod9H4RUGU?=
 =?us-ascii?Q?tUbuqXKmTvuNfgbMbkQ0Q6dopArQzuCxO5gkpXLkm4Ikr+qQuB8KbNMJM4Df?=
 =?us-ascii?Q?ky60wz1/ZfgzFDYVBQBPtEq9aumPN2wOUhKHbLX2YZBJGMt42gDcrEwlQAKB?=
 =?us-ascii?Q?1GerfYsaze08tZ7QowF6u9oLgoYZafCoiHp5E4E+Z36vw1Dr/qbBlJ8++Ewp?=
 =?us-ascii?Q?qiyXdSWdWnEZVIzAhfzZMVIIZKbRsQ9FzX256uZfvt5y1oh0++bTL9Wbz4mB?=
 =?us-ascii?Q?X7a7UaV4gNnu4xByzk9A2KibF8NtMwjoIFLIXOAAMLJ1GAYLULiV6x+QsJnl?=
 =?us-ascii?Q?QCEdxi1AqfhYx2Xs53VbtkNPSsQ8leFxkRLy6UJBPV71gi6ZyUxcxfOrzFbg?=
 =?us-ascii?Q?ClHnEF753zr5h2KDBSXoO9AqOZwBfs5hkljAIh5ttW0IZ1TAuWhsRP9ZvV6m?=
 =?us-ascii?Q?z4LshnByL81EY7bp0peenQf6aiWEcpVnsxBYLhEPmE2htiNZZ87A2j5nhwXj?=
 =?us-ascii?Q?CPrUkPuJYI8kCSGXEuqotM85kFIUxxSw21Thz0nqjtTGSvGVTTkCv4zOfTdW?=
 =?us-ascii?Q?U+I0WWmL+IZDvPhe7u7U2xFI7g3/e8FXD26BFaVXkQwXL8uQWr1617XANuZd?=
 =?us-ascii?Q?2+Q1WEz+0NdN2oZceQ5JNdnOsSIHmVNXR5bQ/dSAX4Anv66w8JecLU0mvcoi?=
 =?us-ascii?Q?7iZZYG6rkKDvHdlpJjlQk6okifOykb06UJyXeSgvdouZYq7SWwOcs7CzhYlO?=
 =?us-ascii?Q?bdllR3OihnHZ5qwXAC2ci7eVtflUf1eG/kaF2DA143frV0ihBaeGpFqxdkXq?=
 =?us-ascii?Q?nWQEMX9pDh4wUi5Bi6OEKf4lbi6rtSeve5B335oZJX3RZoVxsivxKG6sTpcz?=
 =?us-ascii?Q?aum2V3lgT3dcaTQLQQNY2l7Ce4bp3AR0gS5MsAGJqT30flHKDljum8Vkmi+h?=
 =?us-ascii?Q?QWUOz1EeqQS8njZRsp60i4/KKYrOnMfubonw+DOSQqECHtMW2Usb4Vs0Faj+?=
 =?us-ascii?Q?zNoHBK5GeULNFn+Vt0ml3RCwNqrx9d+zWHk2EkYNClEyDc9iWqUeqn/28I5j?=
 =?us-ascii?Q?WqZ/OoY+bGmOXVzLs5FGnqLdDM8d+DjfJC3oCR3PUb7q4+GMFHnvCzkv2PWf?=
 =?us-ascii?Q?sPaDa3IWkKEuGwK9hqBMIHA6q7RiLYoaPi1lkqeqn+Q9a7xOheEe+b/OBUbF?=
 =?us-ascii?Q?MeaKGw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe447f54-e67d-4b01-fbf4-08db2477ccd5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 10:35:16.2777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xaI1fdVgGo55Gvr2bT2VECL3rZSkoDEHhmkkWCHQJMfkmqCUpUwLNNcFUtR6qFKTaAJjV9QRmqp6gGAjDKX1FQiPLexsC9Q7NOFkhbS/hsw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5890
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 08:10:26PM +0530, Neeraj Sanjay Kale wrote:
> Adds serdev_device_break_ctl() and an implementation for ttyport.
> This function simply calls the break_ctl in tty layer, which can
> assert a break signal over UART-TX line, if the tty and the
> underlying platform and UART peripheral supports this operation.
> 
> Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
> ---
> v3: Add details to the commit message. Replace ENOTSUPP with
> EOPNOTSUPP. (Greg KH, Leon Romanovsky)
> v9: Replace all instances of ENOTSUPP with EOPNOTSUPP.
> (Simon Horman)

I'm all for this change. But perhaps it should be a separate clean-up patch,
that precedes the feature-patch which adds the new method. I think that
would make things a bit clearer.

...

> diff --git a/include/linux/serdev.h b/include/linux/serdev.h
> index 66f624fc618c..c065ef1c82f1 100644
> --- a/include/linux/serdev.h
> +++ b/include/linux/serdev.h

...

> @@ -202,6 +203,7 @@ int serdev_device_write_buf(struct serdev_device *, const unsigned char *, size_
>  void serdev_device_wait_until_sent(struct serdev_device *, long);
>  int serdev_device_get_tiocm(struct serdev_device *);
>  int serdev_device_set_tiocm(struct serdev_device *, int, int);
> +int serdev_device_break_ctl(struct serdev_device *serdev, int break_state);
>  void serdev_device_write_wakeup(struct serdev_device *);
>  int serdev_device_write(struct serdev_device *, const unsigned char *, size_t, long);
>  void serdev_device_write_flush(struct serdev_device *);
> @@ -255,6 +257,10 @@ static inline int serdev_device_set_tiocm(struct serdev_device *serdev, int set,
>  {
>  	return -ENOTSUPP;

It seems that you might have missed at least this one.

>  }
> +static inline int serdev_device_break_ctl(struct serdev_device *serdev, int break_state)
> +{
> +	return -EOPNOTSUPP;
> +}
>  static inline int serdev_device_write(struct serdev_device *sdev, const unsigned char *buf,
>  				      size_t count, unsigned long timeout)
>  {
> -- 
> 2.34.1
> 
