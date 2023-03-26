Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10A7E6C963D
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 17:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbjCZPrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 11:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjCZPrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 11:47:31 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2122.outbound.protection.outlook.com [40.107.212.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BECC7284;
        Sun, 26 Mar 2023 08:47:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SX8XuM0atMIGouSal4Lh2psK72OIE48PRuHyrP4Dm3v7t6KQin6KgPvwvZKj/DscgWYjJvnbdmvLkvu/I2OlPXgKEisyh1jp7dsdRVyt5kKPrgrqDImvUokfIcySqoeJat5rlhS5TT68Gr05tIAm8Wea0WGs7YMN1+MROFGiQ793zybr3r518RbuH7Np4fVwtHC1UlfqIIfziM49DNIZX1hpjj16ci3rRGucuTMf8TaD2PsIho3eNWIgqV4isO/WL2zT/jKSYFeFT1gfrvYmpZGIcStxAAo3NHI/otxEOKM+2aOiQs/fJhjT6XF7N032q+oN3glD+jECcZ6doi1x8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lNUepj8OUvJkjBOvf7TT1wItwEC47CK3kkVFfrcLG3U=;
 b=X9yVasjwi7YM1/PSDpLNHgnJAKk69sHZZdtCmSwBbP6xXKyAl7/FZFykGrHTCZD2tPsPkJPMNOHD5zOhHfJAejp/cOyRjzT4qEMnPJ2g/ePDpVeSxFZiCpct2OjA+Jou8fdhs6BtMZGjUwEnMkBuQ3Tm675Eo3/hHnluM28ozer6uQbI7Bd6qXZCSZ8yI6UBDVEwC7I6UuVaI/6n6HoSwRWb30Vz8X1kcO9M5AG4iVcyNWmdjANp+X6RQEhR1H7MKgU0YiAh3yWeJM6pkyVMe8ICM6X5qjy7JDhS1lgYni2fGKNGs7uaTZxLVemMWdv453cdPfYRa73PKFJq9mnoJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lNUepj8OUvJkjBOvf7TT1wItwEC47CK3kkVFfrcLG3U=;
 b=vLpHbz6BtQBe/pgOCu0Go/SWJRF0HWFJTUZLstR4AVhBUgx7VyK5+/ak+sVUPDk2EKlji2WAQ/JBFbwjWlWZ4/bo9XiYvQonpyamNkaiOKdWq2/kVXpLPyw8aEbB4hek1AHTZpyxX72OWxYS4foOS2IX6GYaE+T8ZV9duBq6ysQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3860.namprd13.prod.outlook.com (2603:10b6:a03:22d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Sun, 26 Mar
 2023 15:47:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Sun, 26 Mar 2023
 15:47:26 +0000
Date:   Sun, 26 Mar 2023 17:47:18 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Manish Mandlik <mmandlik@google.com>
Cc:     marcel@holtmann.org, luiz.dentz@gmail.com,
        linux-bluetooth@vger.kernel.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v8 1/4] Bluetooth: Add support for hci devcoredump
Message-ID: <ZCBpBs3i4+RCv5SI@corigine.com>
References: <20230323140942.v8.1.I9b4e4818bab450657b19cda3497d363c9baa616e@changeid>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230323140942.v8.1.I9b4e4818bab450657b19cda3497d363c9baa616e@changeid>
X-ClientProxiedBy: AM4P190CA0011.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::21) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB3860:EE_
X-MS-Office365-Filtering-Correlation-Id: c456dccb-2fbf-4bd7-aabf-08db2e11659e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9LSh2fK3pnIiELcIohXSOOd5ib0F7yjaaF69t0w4XuAtsuvk/UHnruIxDT2kvLUylojI4cR44M97DcMuDYy+ucorFIB7jUwuGcipF3Bz4sVU2CCyqCNY+ANi1kSOgGxcWkAMPYHsxPI3ldOrRRmCsG6XRh/2AYa6tL81tpYgklIogHDukmqq8DhDwG6yTXQgKdxYDON4Bw438RLYE6a/M8Z8yD8CPIVmEJSYD5VxEMp+HzuZCzvwD4mrvLMewKDO9ZU7xbitSoIdfOAoHLl/szfPTBq08MCU6A988jWRCVluE8jk0YC/GSXRfZoKT68pwb9z63AkU6n8dVy1yAB6gmKk4quImHfn8nQLTOwQiAK/NSslSgQFFSZ72nt8SIAQKVziEHP4DhuqmFAT4mgWwjEDMTvsHzifHoBBjiBPce0BkH3vwkRz06qzluiWFPDZNEeJkGQaI3aK8s40AYOsfCNfYhg6i29xpPMZpGSHQpz4Z10rssB1VabkSFkDYTPEaJqrqhQXj2y+6BNAkCYHhTSvHUYYzL7U0p90ykEUeGr0FzOq9NNLPGnrEJD0TE40ksdI4X7LMF6BSm8Flrsi5MGPGt6+H9Llx3KsyKvVCkw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(376002)(136003)(346002)(39830400003)(451199021)(2906002)(86362001)(83380400001)(186003)(2616005)(38100700002)(66556008)(8936002)(5660300002)(4326008)(6916009)(8676002)(41300700001)(66946007)(7416002)(36756003)(66476007)(44832011)(6506007)(6512007)(6486002)(316002)(6666004)(478600001)(54906003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VqXqHNIz+azwSY/i9aZfT5bxwkY/NJkgTywg7O47Lpv6res5zrfV/bAmmtbN?=
 =?us-ascii?Q?3zFc0PH1dyFMSDOsNrVzHQAy6+a92XECxApM2s0jU1AQNoR+NbGu2t/SIDDO?=
 =?us-ascii?Q?qH9g7UZEihrI4OOEiVsuwBbI9LdNkNMOriObCo0HePudIAsRdSWbS6DL8s3j?=
 =?us-ascii?Q?3k8RDujwY+Un1F548RYGvSZ4owf70YC/PAMMBiWoafzPodJoXfZxNkH5dPzn?=
 =?us-ascii?Q?DEcUdqSFKRq8iL2LLYAeYVL3JKD8chOi7xqXBdOpp4dMwARd4e9yRbT8204b?=
 =?us-ascii?Q?O0KYlcd8ELR7ntHQc3B98xMI/aAxpuhSS3ZWh4IqewiVDKn+/X/5A5P9wwyR?=
 =?us-ascii?Q?l6Lo8d60JNS9Ql7SVQNtpGcx8UqX+wLZQ89XEz9NQPGsgr4v4PDOr8jusXKI?=
 =?us-ascii?Q?+6WveQZvIW386AX+/IqLUIAkbU42JLB4xixosPBx0WwOWc+3o/Kj/VICRHIp?=
 =?us-ascii?Q?pMa+ZWoBLTHYYTsXwNuhTkHCzmFTRk7xywqpWygdyjPW62/POeZ7BFXhY4w8?=
 =?us-ascii?Q?DGMkTJVWVCDk/kToRo/Gwlr32abbr7YBgeYplsgF/Tanf+a+KQ4XEdVX8r7I?=
 =?us-ascii?Q?p79CkYoVZgOPSBXUy/kV/2TzkQyhmhmR7ScV5aJ9n0z1IvMBB2/cEd47sd4B?=
 =?us-ascii?Q?okhkd/ckjffVRmXIqKpx9FeFY90g0jj4be9Ndk+9CHr9UHnjbMkI5fr3Www1?=
 =?us-ascii?Q?KwdR97c+kl1vmvVAEIl0J9D1fBmQibl1qdwMfuwn6NoK1OuZgthYOr/9OXic?=
 =?us-ascii?Q?hcv6SoeKtQv1BvODd+1O9zznCm510R3SWe91+Zmwv/TJfS7szcED2I//DVV6?=
 =?us-ascii?Q?W65hcfXAllUAuiVN+jplFxGkrLASkLKXPKqLsGkyJ/x0uhqmTUFi6uMCcF6k?=
 =?us-ascii?Q?6jmKyTQU5qWzCfEBy6D2kHs9DIs3lfZIBCw1pvAlnS1uEoijZM4Hz2Jlgqud?=
 =?us-ascii?Q?t+3u1Or6HjEO6Z3asdPVCPI+ioygcgL6SeIlCSZjk89t1oS6XxBEVtv94sm5?=
 =?us-ascii?Q?eklMmgPMrt/SjI5iOMPfXruWhVTd6IGeEDs9txucj45dnyujrlHw+5JDfuGn?=
 =?us-ascii?Q?4q3b4YepiboXYHsw9nCiWFiyX3Qe52GHmIiQulYshT4wjwi9p5riLruhDvG+?=
 =?us-ascii?Q?iWCvGRGma0jIYq+R+Q7wHq3Wu1PUJYnRiP+toqEQTQt/TuNY1ZZRJ5gOXA5e?=
 =?us-ascii?Q?9nI3lSBKuu3b/xtImL8C3wZQ3HjdRTXlijo4pHC5adf3YN2xDyJLUn4m5oKf?=
 =?us-ascii?Q?Xvp8su67/CcZ4eCSuWXhrUxFARHsJF42LLCnvBx2HVqVbukj+pzcKWklWo98?=
 =?us-ascii?Q?8iirCjLa9QSZHlfiq8V300beb+t3GHI655GUzw5MgT+orzTAcn6wz03Qe40i?=
 =?us-ascii?Q?u525uU4DiFgLDaqzVGJA4u5fYXRN6SNtVI83IkdjXtZvN5wGpMxgqyxPEqPq?=
 =?us-ascii?Q?9BXa1sS/qviLqxaG1470kaYlZ31nCWJOGhCZlgVJSb+LDR5X3Bk3+0usct+T?=
 =?us-ascii?Q?hjcmkiU6ph1emTA/057Sp7S9c5b0Mvi7JS+aPgqGQWG1nPWD8Zidyv1/31wK?=
 =?us-ascii?Q?8gBzgeM8p3+Nh4cIlCPqwFWpcuIycy5iUUStp9PDo4wJvS28VzI9lFX+oEqY?=
 =?us-ascii?Q?t4ueKG1y594/FbSsuJLJUGJk/XOu/rPIpgksCVdKL6zhiAwv6wlrAafNEktI?=
 =?us-ascii?Q?sN2+rA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c456dccb-2fbf-4bd7-aabf-08db2e11659e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2023 15:47:26.0694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y+rwxFe2TAz8ASZVF9P7KI8kn691TopaYRYpirVIsDeBGs4emFA2mSpG/g1XIBGWU5LYyoXoBYRbXefkGJ13TERDrR0Dd2t+CXJtnEDkOKQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3860
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 02:10:15PM -0700, Manish Mandlik wrote:
> From: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> 
> Add devcoredump APIs to hci core so that drivers only have to provide
> the dump skbs instead of managing the synchronization and timeouts.
> 
> The devcoredump APIs should be used in the following manner:
>  - hci_devcoredump_init is called to allocate the dump.
>  - hci_devcoredump_append is called to append any skbs with dump data
>    OR hci_devcoredump_append_pattern is called to insert a pattern.
>  - hci_devcoredump_complete is called when all dump packets have been
>    sent OR hci_devcoredump_abort is called to indicate an error and
>    cancel an ongoing dump collection.
> 
> The high level APIs just prepare some skbs with the appropriate data and
> queue it for the dump to process. Packets part of the crashdump can be
> intercepted in the driver in interrupt context and forwarded directly to
> the devcoredump APIs.
> 
> Internally, there are 5 states for the dump: idle, active, complete,
> abort and timeout. A devcoredump will only be in active state after it
> has been initialized. Once active, it accepts data to be appended,
> patterns to be inserted (i.e. memset) and a completion event or an abort
> event to generate a devcoredump. The timeout is initialized at the same
> time the dump is initialized (defaulting to 10s) and will be cleared
> either when the timeout occurs or the dump is complete or aborted.
> 
> Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> Signed-off-by: Manish Mandlik <mmandlik@google.com>
> Reviewed-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>

...

> +static int hci_devcoredump_update_hdr_state(char *buf, size_t size, int state)
> +{
> +	int len = 0;
> +
> +	if (!buf)
> +		return 0;
> +
> +	len = snprintf(buf, size, "Bluetooth devcoredump\nState: %d\n", state);

The snprintf documentation says:

 * The return value is the number of characters which would be
 * generated for the given input, excluding the trailing null,
 * as per ISO C99.  If the return is greater than or equal to
 * @size, the resulting string is truncated.

While the scnprintf documentation says:

 * The return value is the number of characters written into @buf not including
 * the trailing '\0'. If @size is == 0 the function returns 0.

As the return value us used to determine how many bytes to put to
an skb, you might want scnprintf(), or a check on the value of len here.

> +
> +	return len + 1; /* snprintf adds \0 at the end upon state rewrite */
> +}
> +
> +/* Call with hci_dev_lock only. */
> +static int hci_devcoredump_update_state(struct hci_dev *hdev, int state)
> +{
> +	hdev->dump.state = state;
> +
> +	return hci_devcoredump_update_hdr_state(hdev->dump.head,
> +						hdev->dump.alloc_size, state);
> +}

...

> +/* Call with hci_dev_lock only. */
> +static int hci_devcoredump_prepare(struct hci_dev *hdev, u32 dump_size)
> +{
> +	struct sk_buff *skb = NULL;
> +	int dump_hdr_size;
> +	int err = 0;
> +
> +	skb = alloc_skb(MAX_DEVCOREDUMP_HDR_SIZE, GFP_ATOMIC);
> +	if (!skb) {
> +		bt_dev_err(hdev, "Failed to allocate devcoredump prepare");

I don't think memory allocation errors need to be logged like this,
as they are already logged by the core.

Please run checkpatch, which flags this.

> +		return -ENOMEM;
> +	}
> +
> +	dump_hdr_size = hci_devcoredump_mkheader(hdev, skb);
> +
> +	if (hci_devcoredump_alloc(hdev, dump_hdr_size + dump_size)) {
> +		err = -ENOMEM;
> +		goto hdr_free;
> +	}
> +
> +	/* Insert the device header */
> +	if (!hci_devcoredump_copy(hdev, skb->data, skb->len)) {
> +		bt_dev_err(hdev, "Failed to insert header");
> +		hci_devcoredump_free(hdev);
> +
> +		err = -ENOMEM;
> +		goto hdr_free;
> +	}
> +
> +hdr_free:
> +	if (skb)

It seems that this condition is always true.
And in any case, kfree_skb can handle a NULL argument.

> +		kfree_skb(skb);
> +
> +	return err;
> +}

...

> +void hci_devcoredump_rx(struct work_struct *work)
> +{
> +	struct hci_dev *hdev = container_of(work, struct hci_dev, dump.dump_rx);
> +	struct sk_buff *skb;
> +	struct hci_devcoredump_skb_pattern *pattern;
> +	u32 dump_size;
> +	int start_state;
> +
> +#define DBG_UNEXPECTED_STATE() \
> +		bt_dev_dbg(hdev, \
> +			   "Unexpected packet (%d) for state (%d). ", \
> +			   hci_dmp_cb(skb)->pkt_type, hdev->dump.state)

nit: indentation seems excessive in above 3 lines.

> +
> +	while ((skb = skb_dequeue(&hdev->dump.dump_q))) {
> +		hci_dev_lock(hdev);
> +		start_state = hdev->dump.state;
> +
> +		switch (hci_dmp_cb(skb)->pkt_type) {
> +		case HCI_DEVCOREDUMP_PKT_INIT:
> +			if (hdev->dump.state != HCI_DEVCOREDUMP_IDLE) {
> +				DBG_UNEXPECTED_STATE();
> +				goto loop_continue;

I'm probably missing something terribly obvious.
But can the need for the loop_continue label be avoided by using 'break;' ?

> +			}
> +
> +			if (skb->len != sizeof(dump_size)) {
> +				bt_dev_dbg(hdev, "Invalid dump init pkt");
> +				goto loop_continue;
> +			}
> +
> +			dump_size = *((u32 *)skb->data);
> +			if (!dump_size) {
> +				bt_dev_err(hdev, "Zero size dump init pkt");
> +				goto loop_continue;
> +			}
> +
> +			if (hci_devcoredump_prepare(hdev, dump_size)) {
> +				bt_dev_err(hdev, "Failed to prepare for dump");
> +				goto loop_continue;
> +			}
> +
> +			hci_devcoredump_update_state(hdev,
> +						     HCI_DEVCOREDUMP_ACTIVE);
> +			queue_delayed_work(hdev->workqueue,
> +					   &hdev->dump.dump_timeout,
> +					   DEVCOREDUMP_TIMEOUT);
> +			break;
> +
> +		case HCI_DEVCOREDUMP_PKT_SKB:
> +			if (hdev->dump.state != HCI_DEVCOREDUMP_ACTIVE) {
> +				DBG_UNEXPECTED_STATE();
> +				goto loop_continue;
> +			}
> +
> +			if (!hci_devcoredump_copy(hdev, skb->data, skb->len))
> +				bt_dev_dbg(hdev, "Failed to insert skb");
> +			break;
> +
> +		case HCI_DEVCOREDUMP_PKT_PATTERN:
> +			if (hdev->dump.state != HCI_DEVCOREDUMP_ACTIVE) {
> +				DBG_UNEXPECTED_STATE();
> +				goto loop_continue;
> +			}
> +
> +			if (skb->len != sizeof(*pattern)) {
> +				bt_dev_dbg(hdev, "Invalid pattern skb");
> +				goto loop_continue;
> +			}
> +
> +			pattern = (void *)skb->data;
> +
> +			if (!hci_devcoredump_memset(hdev, pattern->pattern,
> +						    pattern->len))
> +				bt_dev_dbg(hdev, "Failed to set pattern");
> +			break;
> +
> +		case HCI_DEVCOREDUMP_PKT_COMPLETE:
> +			if (hdev->dump.state != HCI_DEVCOREDUMP_ACTIVE) {
> +				DBG_UNEXPECTED_STATE();
> +				goto loop_continue;
> +			}
> +
> +			hci_devcoredump_update_state(hdev,
> +						     HCI_DEVCOREDUMP_DONE);
> +			dump_size = hdev->dump.tail - hdev->dump.head;
> +
> +			bt_dev_info(hdev,
> +				    "Devcoredump complete with size %u "
> +				    "(expect %zu)",

I think it is best practice not to split quoted strings across multiple lines.
Although it leads to long lines (which is undesirable)
keeping the string on one line aids searching the code (with grep).

checkpatch warns about this.

> +				    dump_size, hdev->dump.alloc_size);
> +
> +			dev_coredumpv(&hdev->dev, hdev->dump.head, dump_size,
> +				      GFP_KERNEL);
> +			break;
> +
> +		case HCI_DEVCOREDUMP_PKT_ABORT:
> +			if (hdev->dump.state != HCI_DEVCOREDUMP_ACTIVE) {
> +				DBG_UNEXPECTED_STATE();
> +				goto loop_continue;
> +			}
> +
> +			hci_devcoredump_update_state(hdev,
> +						     HCI_DEVCOREDUMP_ABORT);
> +			dump_size = hdev->dump.tail - hdev->dump.head;
> +
> +			bt_dev_info(hdev,
> +				    "Devcoredump aborted with size %u "
> +				    "(expect %zu)",
> +				    dump_size, hdev->dump.alloc_size);
> +
> +			/* Emit a devcoredump with the available data */
> +			dev_coredumpv(&hdev->dev, hdev->dump.head, dump_size,
> +				      GFP_KERNEL);
> +			break;
> +
> +		default:
> +			bt_dev_dbg(hdev,
> +				   "Unknown packet (%d) for state (%d). ",
> +				   hci_dmp_cb(skb)->pkt_type, hdev->dump.state);
> +			break;
> +		}
> +
> +loop_continue:
> +		kfree_skb(skb);
> +		hci_dev_unlock(hdev);
> +
> +		if (start_state != hdev->dump.state)
> +			hci_devcoredump_notify(hdev, hdev->dump.state);
> +
> +		hci_dev_lock(hdev);
> +		if (hdev->dump.state == HCI_DEVCOREDUMP_DONE ||
> +		    hdev->dump.state == HCI_DEVCOREDUMP_ABORT)
> +			hci_devcoredump_reset(hdev);
> +		hci_dev_unlock(hdev);
> +	}
> +}
> +EXPORT_SYMBOL(hci_devcoredump_rx);

...

> +static inline bool hci_devcoredump_enabled(struct hci_dev *hdev)
> +{
> +	return hdev->dump.supported;
> +}
> +
> +int hci_devcoredump_init(struct hci_dev *hdev, u32 dmp_size)
> +{
> +	struct sk_buff *skb = NULL;

nit: I don't think it is necessary to initialise skb here.
     Likewise elsewhere in this patch.

> +
> +	if (!hci_devcoredump_enabled(hdev))
> +		return -EOPNOTSUPP;
> +
> +	skb = alloc_skb(sizeof(dmp_size), GFP_ATOMIC);
> +	if (!skb) {
> +		bt_dev_err(hdev, "Failed to allocate devcoredump init");
> +		return -ENOMEM;
> +	}
> +
> +	hci_dmp_cb(skb)->pkt_type = HCI_DEVCOREDUMP_PKT_INIT;
> +	skb_put_data(skb, &dmp_size, sizeof(dmp_size));
> +
> +	skb_queue_tail(&hdev->dump.dump_q, skb);
> +	queue_work(hdev->workqueue, &hdev->dump.dump_rx);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(hci_devcoredump_init);

...
