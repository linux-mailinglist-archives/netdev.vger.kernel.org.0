Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22A943F61AB
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 17:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238310AbhHXPc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 11:32:27 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:45196 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238218AbhHXPcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 11:32:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1629819100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SBgygmfNCgF/hbTlSpP4QhROisBR3Nmc6XYtY6xdQdc=;
        b=NdMuiizv+09/P+2GWbmU7SfVE11DkTHomB7uJMu+1k8ga8btRLEK0c42W8YhxvO9QCnKiB
        VoQGvPUCvBLh6lcAVKxpC8+0YVooQ9DNfpaxeY7mnI5wXrcFmsqL1It1aj4IUMuteqt4v9
        cPfD69FOgqIPzIqvvSEwfN5ImnFUWsY=
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05lp2110.outbound.protection.outlook.com [104.47.17.110])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-22-eHvpKVUUOgun16UiTqzpcw-1; Tue, 24 Aug 2021 17:31:38 +0200
X-MC-Unique: eHvpKVUUOgun16UiTqzpcw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O0D4Klde9QS0vm2MUA05VzhySDZNTXxEBYo7NAVupZDNY0E6C0b81bX83VeVxjEugH3X8bcZdJdjoU81e8SfIesOldIdu/hIrBm513b147ZC5mKJN/D3aFd6/TufdY8BCQlK24UAfvzARqthpp600A13mtghjU+DRe6pwBTyUeZlCRnLFMeU9a0S4rn943G6r/e/HXGCCkYbf4/B0bjbQVHFeV7rNZX/Axbk+R45n1fMmAN47POcnUEHwAzroQMHrYLxO9RO5A2d9Kk93ipdMR83/yTyw4BElcoqhhbIpRR8GmCYj7Sf01rxIpbPa6jlGpwUYS2dhPLIX3BzqL7tGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SBgygmfNCgF/hbTlSpP4QhROisBR3Nmc6XYtY6xdQdc=;
 b=OCMseRA4tP33hHBlTpW26E/sbt/GBgYGGvyai1gajdqex1XH+Me1lTwNVP3EK7FktqcTb0gWy62tKK6JTf5J2Rm+R4T1EmneQDrT+DcEHIvb2fxI9/rdA9BTwWNPWOrBb/uKhu8H2hDV5vzEF9K3Tt/X3TLLPWV82Y9jmAHhCkR5zgaPWfQUzZWFSkbQeZbM89grw7HxXdUeL94qO7maehqipLNr8wVxE2DdMpgjhnUhPm1J1ULwITPHwocgg5YY20lH2tU0DOREO/4EzUSWBSZ/kuvBaQfWIg0/hx5t6FnSBODcIhQ3XzxRn66MVy4N7/5SxbX+6Nn6HEv2zqIvow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5587.eurprd04.prod.outlook.com (2603:10a6:208:125::12)
 by AM8PR04MB7426.eurprd04.prod.outlook.com (2603:10a6:20b:1d7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.24; Tue, 24 Aug
 2021 15:31:37 +0000
Received: from AM0PR04MB5587.eurprd04.prod.outlook.com
 ([fe80::4822:460f:7561:33bf]) by AM0PR04MB5587.eurprd04.prod.outlook.com
 ([fe80::4822:460f:7561:33bf%5]) with mapi id 15.20.4436.025; Tue, 24 Aug 2021
 15:31:37 +0000
Subject: Re: [PATCH v2 4/4] xen/netfront: don't trust the backend response
 data blindly
To:     Juergen Gross <jgross@suse.com>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210824102809.26370-1-jgross@suse.com>
 <20210824102809.26370-5-jgross@suse.com>
From:   Jan Beulich <jbeulich@suse.com>
Message-ID: <61f366a8-1597-f4a1-7727-db23962e856f@suse.com>
Date:   Tue, 24 Aug 2021 17:31:35 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210824102809.26370-5-jgross@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR3P189CA0058.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:53::33) To AM0PR04MB5587.eurprd04.prod.outlook.com
 (2603:10a6:208:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.156.60.236] (37.24.206.209) by PR3P189CA0058.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:53::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Tue, 24 Aug 2021 15:31:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff049787-d120-4b62-66db-08d96714433d
X-MS-TrafficTypeDiagnostic: AM8PR04MB7426:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM8PR04MB742635D53DB390EC06F2A706B3C59@AM8PR04MB7426.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wYtqpYBRSGcqBBtp2fpI6mXhyYMIrOTKZcImzlCODcfUvp882RVGTHmcUU9sGpzcBHfE6JA/9aXqnQjBllGZ5qPZJdmlPuCEbrp+FjiQmeChEiSceNxHoHBkXAulSCRzOTnks38Ccca40zFNUnpTwaVrJ2A3MXExjvCGPP95aAViqTJFwvBIcd/juAnLDjrOgMoRDsWZCIc+ZJaUDCXrHyBXRi/M3ndbWSxR2Z3I6ReCbmjFAw72vVuaS5GD3MRP0cKki1H4DYyVO+iloIn8X69aF7a7VaZk2V8S75F6FVuabJt0SbYh3ftKWAJ40rBZGOD8/lRZsKkT9Yl/ZiATlvMKY0Zv+POpnRlW3pnDMFieWOEZyHhkTG1iwa8BmjnhXHbGEq5V7HHqldlwJt16SQJ3TLCB/ReWSJQI0N5NzE4w/d1v8S5SUPXRFVzEZBbvEGxn+cqr/jDWMSTQEVAWmog6YKeVA555VcI6yqxtNtu3Q2GKeI5afp+KquUSe/PW6Qo/76+nigV+3OFsTrBd5buLk2/xiTMpHGI22HveBS6zG37lgZc8BVuXBvfpZ2Z44kwsFiBoA2W4EZDj6P2/ZmAE4JUD+ockc3zPnG4c3vtdPR2uNL0gimhLOBooRbkeqDmM1qp3aYglkH6EwewRm94PsU8+/nKkQqmmSJxb1EKFbbSeCnv1D8ciCQ9sAusg68qWtuM2WDQN3f0QbRlRTDs08kO35k/8p6mdyhbjWq0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5587.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(346002)(396003)(39830400003)(136003)(2906002)(316002)(2616005)(54906003)(16576012)(31696002)(6862004)(66476007)(956004)(37006003)(66946007)(66556008)(4326008)(83380400001)(6636002)(86362001)(8936002)(53546011)(38100700002)(31686004)(478600001)(5660300002)(36756003)(6486002)(26005)(8676002)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eHhWR2xHSWNWVXBva2tJNUtaUEdrWUl4NFpjOE8rQ1FudU1CMnpEMXFBYXk3?=
 =?utf-8?B?V2FvUGxHb2Rsek5zeVdJQndJWGN5SHVtYzYyZ0plZ3BKYmpPME8vNjVQb1dD?=
 =?utf-8?B?UTUrMlI0U3NNeFhGVnJPY1BxRytueTU3MzVPcFdtUnRQOTE1eC93NTdaZEJy?=
 =?utf-8?B?dVRVTXBvcEdOUENsVzB6QUdkZkEyZThmd3hnbEpSVXpJRmFaTXJrVkhMdS9U?=
 =?utf-8?B?ZlpVemxuTGtNcHNQSmNQN241N3RHUUVFVEJ3UmZYSUZoRUtTaGd6dXFTVWJQ?=
 =?utf-8?B?TlVDMnBXUFFwek1GL2RBSVRsd3ZkdnZ5by80OTBDdHBoQXhyOVdTeVlIQW9R?=
 =?utf-8?B?amVJTndKQlVWa2Q4T1JTMVZzZDFwSWwwTzNNQkdtVUNGK1dYaUVzeE1Ec2tl?=
 =?utf-8?B?ZUpUb3k0V3AxZ3FpeHhUWVpSL2tIdVRkRUVBVEhBZTEzTHFES3c3Rzdpd3Rp?=
 =?utf-8?B?SHBmdUxKMmhQL3BGckhueDdDcjUrSHBnd0h1NnliSjBEOXJSaTJmTFJPUFpB?=
 =?utf-8?B?dUNXZGpPVEdtcnVkdldhU1RJVkt1WEl0YXVTL1gvTnNFNDBmTDEzWG9Pckty?=
 =?utf-8?B?U3pWZ1N3bDRnbjBVM0lQZGppZzI1bGZIV3NhNndOdm43b29lZ0QxSmU5U3dl?=
 =?utf-8?B?N1A3dnRHdmZVSWFCMEVHRTIxeXVEQlZlSVZsTVA2V05IQTJjcnBEbjZBQ0Nl?=
 =?utf-8?B?YXJwM20rcGdycGp1VHI0ZHdTS1V5c2tRSnZQdXNhYmd2U0wzTHIxbUZsYlB0?=
 =?utf-8?B?alZQSCtQRjNJakFZWjFyWVU3YThZdkV2REV2RHRNekR5d1RGZEQ0RHo0b0lC?=
 =?utf-8?B?WmNIMjlpTjg4a05hdnRtV0tLSVVtZDlGUVBVTTd4Uzlha0NpV1A4RitTN2RG?=
 =?utf-8?B?dGhLY3dzR1Nkb056M1B3OTFCVG8zdjF4V2UrWnh1SlNqM3RHUTR4T3I4azYw?=
 =?utf-8?B?eVBWZHI4aTZ4V3Jld2kzeEdBM29iTXNCSXp3Z1R5ZDJWWnJhNmlvR1F3OU1a?=
 =?utf-8?B?MHBrZUl0aXRqQzJGU0U3TExrOWdyWG54NHY4bHdHSUlIbkpuWTVpdCtoN0NG?=
 =?utf-8?B?ekt2dWc2K3BXZjlJS2FTUFAzdm5KbzFiM1MxVFI5ejBqWDdSTTlVSTE3VUFq?=
 =?utf-8?B?c05YdUpVMy95WTVqZUl5YkNqcHo4SkFPeVBLNmtFVlN2RlJtV1U1VmxMTTJG?=
 =?utf-8?B?bGpVd21PTzhpbTN3d1NySHplVHpuU0xveFhNSzNHZXpyYWhsYmdJSngvYkRp?=
 =?utf-8?B?RU82MktOdXRUbzRVK09vSkhmb0dsUitwNTdQV1VvWjlhWC9acGdTSzd3NUxG?=
 =?utf-8?B?NnNuYk9FUExLUXhmcmo5UEFqb3lpMXJMaXdqeVlCV2ZPeTN1ZFRBZFViWFAr?=
 =?utf-8?B?ZS8rVHdZQ1pHODRPM3pOSEtnbEJobmZ3MEdQSkZFYTdJUXVNN1dmaUlyWSsz?=
 =?utf-8?B?cTN3K3B6cUFVU3FVSDMvaUgra292WFVQdUh0YVUvY0prT0ZoelpsWXFjZFBK?=
 =?utf-8?B?Sm14V21XVzdPTWlEK2RnemZ0WWU3VGRabC9HMGFSTDh6Z3hHVDE2SWFrKzdX?=
 =?utf-8?B?ckhrajJ2RkhTTHlNcXFCTHJSNktxT29ISXZVU29QWnE0UGVkOVloWjJzVVVn?=
 =?utf-8?B?eDVrTlZOeTBFMDJoTmxia3ZvWER6eW1RYkxTYXFlYmdRMmdjby9CZEg4RXlQ?=
 =?utf-8?B?ViswTnZNcDRPK2dURFBOV2xFdHNYdzllWFVJcVhCdjlHYTRKNHpwRmQvZWZy?=
 =?utf-8?Q?4kA1qNSylTPaHXaAnGNfekhljDY9y9xHaYJXcyo?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff049787-d120-4b62-66db-08d96714433d
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5587.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 15:31:37.8258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: snxqXbaEdiwXSZlwRsia4FVz4b8HQprv05C+7e/0YRg1fMUMXJukut/VEI4OO5UEuwACYpl2SIDfiILjPKXMkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7426
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.08.2021 12:28, Juergen Gross wrote:
> Today netfront will trust the backend to send only sane response data.
> In order to avoid privilege escalations or crashes in case of malicious
> backends verify the data to be within expected limits. Especially make
> sure that the response always references an outstanding request.
> 
> Note that only the tx queue needs special id handling, as for the rx
> queue the id is equal to the index in the ring page.
> 
> Introduce a new indicator for the device whether it is broken and let
> the device stop working when it is set. Set this indicator in case the
> backend sets any weird data.
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>

Reviewed-by: Jan Beulich <jbeulich@suse.com>
with a small suggestion:

> V2:
> - set the pending flag only just before sending the request (Jan Beulich)
> - reset broken indicator during connect (Jan Beulich)

With this latter adjustment, would it make sense to ...

> @@ -416,6 +440,12 @@ static void xennet_tx_buf_gc(struct netfront_queue *queue)
>  	} while (more_to_do);
>  
>  	xennet_maybe_wake_tx(queue);
> +
> +	return;
> +
> + err:
> +	queue->info->broken = true;
> +	dev_alert(dev, "Disabled for further use\n");

... hint at that behavior here, e.g. by adding "(until reconnect)"?
That way an admin observing this log message will have an immediate
hint at how to get the interface to work again (if so desired).

Jan

