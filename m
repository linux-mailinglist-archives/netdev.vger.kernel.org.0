Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D04A96AE53F
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 16:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbjCGPqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 10:46:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbjCGPpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 10:45:55 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2117.outbound.protection.outlook.com [40.107.243.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB968B040;
        Tue,  7 Mar 2023 07:45:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gZ/sYQWL/uBAA+lX3KrbDGF8S6EkOLjVWoMpqXcYCQWMmTQNv9uDBQLD+oWjFRqZIc9/AgoPQppQkTf6/0vl5tMHlOptqmoSI9RHROAY15m4Esm2uuYHuBZqjTELmH7IKRxgduhLhKYY63fyjbIHncjTCLiPNWyX4Of2xSuibRm+Q/7nurS12TaBAFmM3Z6t5cEZSGQJMEQkbICRMbRkjZO8L07jPf1pFNwPgwdd9IyQPyqFMzxak+CiZFQKrd/H5RtqzLrs1c2+WYUIaKShOWlD06oqwRV4iWcPNCKwYxL4OxYlvaihfaDHiPKjOkDoRaugrVosJxJOAtH+C6SwTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ac+Pa402ow+a0GGI4hO3wexNlNtuuIAz2rUuy7z7r0A=;
 b=Z7+NkR6crclocgUQSC9zXuqe5x5itQkFgFN/qogfKgl75iyqwhDyz45kgsJNKzAa4cVntYiM0TVPMIQiVtp2bcvg/PX/6zjLHsxbRftq8szPe0Bpq7DccdTH6aq7VlvXZxqiR7zrZdNyY5pLhtUvO8SrYtVJyikAAhG8zHqy30EWyaT4SyasQiCTt+qZqi+cOwpqan+N9Zm1mwCFe66ZVTevnFZX22tR+u/0aDZI117eYdVdYmIyjiNDuUPgADF64iSC1rU20QgtnnzjcBV6YKgwldbKo6D8TN5OUb1HWyDym+Bn6ifAI4sBZsxHTdqUar0FOZG6HJRevRTZr4yV+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ac+Pa402ow+a0GGI4hO3wexNlNtuuIAz2rUuy7z7r0A=;
 b=sOGIy7KyGOkmkR6/cItcGlRTM1ZktK0l5UpEt2gkZbcc4drF6j47SH/rcb+ebKrQ1ImRVZXzscBwDH8LLtx/Q1FdzRpJCdvko1ZPfotQpg1TK526yeeQpNZftBxxCVj93h/2IgoQhOrWr7oCddf3T2qOJA7YGOEd9PRhDUKdIyc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS7PR13MB4685.namprd13.prod.outlook.com (2603:10b6:5:38f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.27; Tue, 7 Mar
 2023 15:45:37 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6156.029; Tue, 7 Mar 2023
 15:45:36 +0000
Date:   Tue, 7 Mar 2023 16:45:30 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Minsuk Kang <linuxlovemin@yonsei.ac.kr>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org,
        syzbot+1e608ba4217c96d1952f@syzkaller.appspotmail.com
Subject: Re: [PATCH] nfc: pn533: initialize struct pn533_out_arg properly
Message-ID: <ZAdcGkqnfRDwJq5y@corigine.com>
References: <20230306214838.237801-1-pchelkin@ispras.ru>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306214838.237801-1-pchelkin@ispras.ru>
X-ClientProxiedBy: AM8P189CA0004.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::9) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS7PR13MB4685:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e46e14a-36cc-4718-fa13-08db1f22fec3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LKndBUj+Gyylx8ixpuFekTriT21GkRzPLouKRQBkUX2Wk9K9QK005CwrW1RpgTZhYCKDZFCCEjAjFZkwzEq6QWWbjJwQUTNi7j4KORiWXMGk94xpVZxlGojv5FOogYkA4mc1bMgJiFJ6Z7gsgR8x2CRSo9Fbqn+GPfwQTVnhJi7Ac7dn8vuX33Wdc3Sh/UNJoyVdD4BbpOeBqVMse1hLlObANzVbrpZWBA9WHGdIyQxwiPkbcoAlmGs/uVQw11EJ3hFIo4R7eCDxUZxjXtsYOe4BzrPzR9u9Cq3zenXgxVgdl/I7FOLGbDHq6o/visZIDoPZmcXbs7rzvNUhPV1DimSjkhv9D9sZUOw/fOZNnl8frrSvx+50RN8GkUylemYGbDtciu3JHsAW18f1tdAvqzRDCGOqLpE37JvqWoUmSrB8i05R52oTwI+MmvP2JoE1T+wPZjwtI1Jy1/YwEOj3Bo4896liKCyS0oUn7nWERt7OMwhZRpgje8mW+nkp4zBSm1KcTD6STeA2/0aNK+Eb40YjWBGhhN+rBcglPbac06XiIe4cPOIoNltcuPQ+ocOgGC/xmK0Pjl8thYyBAyqbGP42xdHDrhHhRbxOLweR7PwKFah70jxty6tiYGe5uce44eVAdeKdy3QGDsaOxR5jzA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(346002)(376002)(136003)(366004)(396003)(451199018)(36756003)(6666004)(478600001)(83380400001)(6486002)(6512007)(86362001)(2616005)(6506007)(186003)(8676002)(8936002)(66476007)(66556008)(4326008)(41300700001)(5660300002)(6916009)(44832011)(7416002)(2906002)(66946007)(54906003)(316002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1ez5w6/02gHnCHETX76h1HwqhtD1HXCVgiea1S6zGbwPKwt1318piOz8JyDA?=
 =?us-ascii?Q?4u7noXR4INj+qNKMn0GKXGqwvV7VihmZ5mAYKpUWR1w3s7rwehZ5mlsv1utB?=
 =?us-ascii?Q?ExDuIN4wLuvozwCUEF0Phws3cwl2efWRMT/Dbxe7QeGZOiHCOlJTQWYxFSmk?=
 =?us-ascii?Q?AqnXQwJcQdJdMXNfuciYeKEmogw2NM3hxC3O99ifOm1WUc7AUry1mhk6VDMg?=
 =?us-ascii?Q?I2o2I/jbGv85WTmVijy6q2qoIwk21ovOvPH9lDy5DbRlosjc/6VMoO7Kq41t?=
 =?us-ascii?Q?A7JPa4I4tmn4t3WLQzphBvlAFIOPxHSQ8jNOKKte4Fs6l1TQHURsC/+ThgoI?=
 =?us-ascii?Q?bORufsPNWrT3cQaYucUC8Wia7wKpVyfpsSSZ+W9pZoDplGx9Li1bm7KBigqm?=
 =?us-ascii?Q?MEcFVUDqqOu9zCT04VIawJN5eobC1n+AisaTF2jlmwIP4A5wH0JIl7kSaOFI?=
 =?us-ascii?Q?sK37YN3gvZlGH2qyjt79lG8l69yQtCgvp1/1J/Mj0F3ue/SUM8JRTRuz5pfZ?=
 =?us-ascii?Q?Z5+3m8HSJZky8+b4NYv+OAK1uv6PMKFzJ18/UHRZOsNn/XTifUSkIIm94lzD?=
 =?us-ascii?Q?ob0rg3NiyRvb1gbFkKvXbLZwa+9I98epGgu50k4aS3ZQ4eAusrM5pica0EhE?=
 =?us-ascii?Q?aq0rbYfEfSU0MjJsMZxeZxYzPqctScu9JmAuzK9Fe2b30FAH6C+nL6dQ1ZtV?=
 =?us-ascii?Q?usLMtzCpeLRmFTOISGJcdqy3ZPdBUPNlyHYNH8O/2r36DcVwajKfwYx53FoE?=
 =?us-ascii?Q?baeV8LiI13j2BU1rQNjClkuyCtucBcDl/Fc2ITdOPddqBlnNCSS9/hR1SIh9?=
 =?us-ascii?Q?GGuNFxj82ak9GHY6prEUS/vlNsAo29rKHDthXtcHP+Z5iqBZGFaboIxONusS?=
 =?us-ascii?Q?XtiEQR+UJoUignchvkPlRL5uZC+tMO7csbO3tw5ZgI+nfMD1r/1zSk6SM7Z/?=
 =?us-ascii?Q?gTkeMV81niCS1oOgoPAj1AZ83+jpktLKX2X4+I9YKbUHApu3uqAAFTyUpE2N?=
 =?us-ascii?Q?JW0lsd+LtTGdUNIVY0AwXmsBFvEQH6TnfzLMyZc217jzAlPSARn+tUzAp1We?=
 =?us-ascii?Q?sMpxIfhAsuVQRld1atyqxJbOBRJpbCcXtPEBUxNnME9N4Nw1MH3No3+i6AFk?=
 =?us-ascii?Q?xYdXhU9PQtvyxvP8CexayDN8DcfArnv1HjMBzdqBXfveqWwesx9XxLqrbz1i?=
 =?us-ascii?Q?AiYv3MIZfG75vPK2lZ5uOZS/EeOi7tAcjvm52k2S0FIozQJ4hP4gikF+DXCt?=
 =?us-ascii?Q?2zE2WgC6XGDdu/Wa5L/HQmqMkc8mMVwyGw24G3mAgbXqWZuzlG9Vl8bO0qcx?=
 =?us-ascii?Q?bOO/zaklSrQxKRLTnUHMmMIFb58qgTPfy42Bn+n+moe0fDsM7qetkZ3wj35n?=
 =?us-ascii?Q?XJI7sXvgMPXPrrt/HTiIwx5/l3O+45PUnFfTdXs7PYIeJbOTkspEhk5kPvNv?=
 =?us-ascii?Q?Jo6jbZ7Ylj1bUBP0Oqejj0q3F6uzvKD80Au4eLc2Px11XSykI++UkUOznwkY?=
 =?us-ascii?Q?xKOycSJUb+uL5JHIbn7EJUNIea9bEEcsbllCMfQ6+hfHm5bbvS+LXNfA6o0V?=
 =?us-ascii?Q?9eOS9LXWHbQ2AzVUB1XYRRp5Ge3apJKP0W/62ZYVjc8RwpZlzjSBkKcrovtj?=
 =?us-ascii?Q?Wk5FmKwFnzebUwhCj1TjYpfZD3bU8qYQXDmfPn5SKCmDFZv3PzqtMIXAkgKd?=
 =?us-ascii?Q?QSDGAA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e46e14a-36cc-4718-fa13-08db1f22fec3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 15:45:36.8537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L55z0Ew7ro3zrvHBDwryPOqHC7g8Yuk3U/Eq9Nc/tXTeWWoKv8ADIOwzfcTJ705ZTRoZTTNCr11Jx5F/pTu0TiKD8P7nnmvJOTLA5Fyy2Ew=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR13MB4685
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 12:48:38AM +0300, Fedor Pchelkin wrote:
> struct pn533_out_arg used as a temporary context for out_urb is not
> initialized properly. Its uninitialized 'phy' field can be dereferenced in
> error cases inside pn533_out_complete() callback function. It causes the
> following failure:
> 
> general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 1 PID: 0 Comm: swapper/1 Not tainted 6.2.0-rc3-next-20230110-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> RIP: 0010:pn533_out_complete.cold+0x15/0x44 drivers/nfc/pn533/usb.c:441
> Call Trace:
>  <IRQ>
>  __usb_hcd_giveback_urb+0x2b6/0x5c0 drivers/usb/core/hcd.c:1671
>  usb_hcd_giveback_urb+0x384/0x430 drivers/usb/core/hcd.c:1754
>  dummy_timer+0x1203/0x32d0 drivers/usb/gadget/udc/dummy_hcd.c:1988
>  call_timer_fn+0x1da/0x800 kernel/time/timer.c:1700
>  expire_timers+0x234/0x330 kernel/time/timer.c:1751
>  __run_timers kernel/time/timer.c:2022 [inline]
>  __run_timers kernel/time/timer.c:1995 [inline]
>  run_timer_softirq+0x326/0x910 kernel/time/timer.c:2035
>  __do_softirq+0x1fb/0xaf6 kernel/softirq.c:571
>  invoke_softirq kernel/softirq.c:445 [inline]
>  __irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
>  irq_exit_rcu+0x9/0x20 kernel/softirq.c:662
>  sysvec_apic_timer_interrupt+0x97/0xc0 arch/x86/kernel/apic/apic.c:1107
> 
> Initialize the field with the pn533_usb_phy currently used.
> 
> Fixes: 9dab880d675b ("nfc: pn533: Wait for out_urb's completion in pn533_usb_send_frame()")
> Reported-by: syzbot+1e608ba4217c96d1952f@syzkaller.appspotmail.com
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> ---
>  drivers/nfc/pn533/usb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/nfc/pn533/usb.c b/drivers/nfc/pn533/usb.c
> index ed9c5e2cf3ad..159b331b3bf6 100644
> --- a/drivers/nfc/pn533/usb.c
> +++ b/drivers/nfc/pn533/usb.c
> @@ -162,7 +162,7 @@ static int pn533_usb_send_frame(struct pn533 *dev,
>  				struct sk_buff *out)
>  {
>  	struct pn533_usb_phy *phy = dev->phy;
> -	struct pn533_out_arg arg;
> +	struct pn533_out_arg arg = {.phy = phy};

nit: This doesn't follow reverse xmas tree ordering - longest to shortest line.
     It's probably not worth respinning, but I expect the preferred
     approach is (*completely untested!*)

	...
	struct pn533_out_arg arg;
	...

	arg.phy = phy;

>  	void *cntx;
>  	int rc;
>  
> -- 
> 2.34.1
> 
