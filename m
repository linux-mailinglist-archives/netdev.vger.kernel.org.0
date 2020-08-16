Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E30082457AA
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 14:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbgHPMvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 08:51:43 -0400
Received: from mail-dm6nam10on2075.outbound.protection.outlook.com ([40.107.93.75]:47282
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725843AbgHPMvh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Aug 2020 08:51:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LaV/2oRk3XXnxG5xtsZXsOIYXMpbihO5c63UxoZbJ191zTRiniAQoPbZJQsREnmQAq+y3aJSmUHPooZ11ssBQ3jyA6KZ2MTDoKMBviHOn4M2mryQylH0ZaWf1xNYGG/HXJphkmaL/T2rUD0iJzEVRA/2JKNdTHrSX4O6mrr732K/jkl/gAs9VrEICXyEh5Hj4uaADomCAioc8jXLXo5g1xiyJsRRt5p/5x7zIQin3Fn8Y5MMgclsudVCJCwbKDm7TgfFOC1jFDRXhL5SaFa5HNCCs6pw4k5FAY3R4wpVixNGuiKrmMWEGW90M5ccJQrh9hXFE2XEnkV845N6ixMvVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1wcR3tBxSpiQe8EiW/zmwIYpK+fdNDmO7OGZngP1Nsg=;
 b=NJx8H60UauJSsQfZO+xCezA10zYBS4IbctSw2RY2DFM++lvn+1GIa2y8mOia1nEBtJH2Immr0kPXUZqSZrO+sfAQ4ODmQw4jjNGUXS177RBcXJDkqw14HdvvfCCCIVS8qv5grhENEoEZj3j7Qr/GIQqeGs9nnYNIyZBe19dsFvii90+Y90peyrDpyqwiTev6knTxbFmMYvVHwIfdSREXOzhPk7dIo7bs+WyOKqc3hB2z9Fd5xYWK+tVtCXYtVBzz813Qb28VHPjcDOx89CBV9HA+upL9R+mC3fR4Z1sv0vQNXV5APV0Im5kM1/GhjjJr6+I4SM2pcuKGoLP3D8Fw9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1wcR3tBxSpiQe8EiW/zmwIYpK+fdNDmO7OGZngP1Nsg=;
 b=Hmz1GgM1TkM7BNPgiBMVUsqd6mt5Gc1NoIvrL5dQVyJjgCrI2muzZgelCfiaEHARTSNzbHKa2oB3zqOvWf6flFx3GdVePzSdRYvjgTv3SMQZri1IRmkquFc+jsjZSAfA8EKCKPrDmg3zK2cPw4HK8JHpajVdYUZmNj8quQbeqd4=
Authentication-Results: ericsson.com; dkim=none (message not signed)
 header.d=none;ericsson.com; dmarc=none action=none header.from=windriver.com;
Received: from DM6PR11MB2603.namprd11.prod.outlook.com (2603:10b6:5:c6::21) by
 DM6PR11MB4347.namprd11.prod.outlook.com (2603:10b6:5:200::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3283.22; Sun, 16 Aug 2020 12:51:34 +0000
Received: from DM6PR11MB2603.namprd11.prod.outlook.com
 ([fe80::b16c:41d1:7e54:1c4e]) by DM6PR11MB2603.namprd11.prod.outlook.com
 ([fe80::b16c:41d1:7e54:1c4e%6]) with mapi id 15.20.3283.027; Sun, 16 Aug 2020
 12:51:34 +0000
Subject: Re: [Patch net] tipc: fix uninit skb->data in tipc_nl_compat_dumpit()
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     syzbot+0e7181deafa7e0b79923@syzkaller.appspotmail.com,
        Jon Maloy <jmaloy@redhat.com>,
        Richard Alpe <richard.alpe@ericsson.com>
References: <20200815232915.17625-1-xiyou.wangcong@gmail.com>
From:   Ying Xue <ying.xue@windriver.com>
Message-ID: <21e10855-4c78-c35c-19a4-818cbc70f03d@windriver.com>
Date:   Sun, 16 Aug 2020 20:34:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200815232915.17625-1-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HKAPR03CA0017.apcprd03.prod.outlook.com
 (2603:1096:203:c8::22) To DM6PR11MB2603.namprd11.prod.outlook.com
 (2603:10b6:5:c6::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [128.224.155.99] (60.247.85.82) by HKAPR03CA0017.apcprd03.prod.outlook.com (2603:1096:203:c8::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.15 via Frontend Transport; Sun, 16 Aug 2020 12:51:32 +0000
X-Originating-IP: [60.247.85.82]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d80fda9c-182d-401c-52fc-08d841e31b10
X-MS-TrafficTypeDiagnostic: DM6PR11MB4347:
X-Microsoft-Antispam-PRVS: <DM6PR11MB43476F506E4679DD0E14ECB9845E0@DM6PR11MB4347.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:741;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8HnxWf6PApnwxvxe0czQMe83K0Yc6isJdhELcAXJ3JzzIDznAUXnn0wrxam1d2YxcJkRhZzpp+G3UtPH1NhfXdGoXmdSWUkVmcmgqMtPhKE8mE95+8RPGI8gaSP62uPBFOAPCwF1ZaSlxD5lhog3w+y+bSimSdL4gGhWSBxT+Z/rWBBtSbVMmZDc8rxi6HK8OYmMU9SmU8jMJOmDikQWL/6Z3YNV+XDRrdwXqom6+3Tsny7Nysj1yTet6/hNeqiyGCvlXuYCQTWFYVhWhrA9IYSvVthDo3GG34PspV69zD4pX+NZFR8pWK+/dOY6ncrivRAnxXcw6w420OvpPf4YYWorVmJE40jwpQzzBC/0DU/ndsIHQmFQED5ygbEcL4JhfRSztOCkcQvvl4NzM1HH8Y9Mn7fcOmSrax1jRr+PcB4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(376002)(52116002)(54906003)(2616005)(66556008)(86362001)(956004)(66476007)(66946007)(44832011)(8936002)(5660300002)(6666004)(16576012)(36756003)(31686004)(2906002)(8676002)(26005)(83380400001)(6486002)(53546011)(4326008)(6706004)(186003)(16526019)(31696002)(508600001)(78286006)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: e0ZvSxO+X4IAvcNYOnO4rz9fj2PQ1FewpGZCRss26JSJQhxyN8TcpMkcUii7w61YjuCaWwvYpD5JKfZ5cswDpdoD+IxAWFVqmA1Jce/1walE4QIkdCslQ32LEvGnZP/11/8c4Ztt8FwuD0ZKFhGzeE3KqwvXEXV2IqA5Fwocw4yS1MqJuxX4O5y1/TDQV7LYq2t0Ko5DyFDJ7nzwsEwmLcibnbzjDzOjaaUMxWPLllCXCeFWNYfQlboHN+lmy3IAhuzz1MsIX0HoBnu5IJ76w/PPv3AviQ1nxG88IhC+pCYyESJWPs4Xgo568tGXsQz79cSh1HOaYTlY8HXujSHRT4AN/heztNC8xfR7luaXvjhH/oSicd2wu+RlN55fnhRuUxlFD0K7UcouFfeuBhVh8ej/JDJAIkpoJF8+/xCFgDfad8Piix+42Qgh7MmZm0GRcpTtwwtF0vjZ7u8zj/UwFDuHRj2Z0Y8VphZT98OcBI/qS0KT0PyzuRLjDfVm+gnfAO+GpUvbjIlVdEnWETuhp85+tdyqd8ItVg1ToBv8pcB0qnA73HHFBh6/+nMtFRdy0J9DXs6sTEmWygrZlRd12iex2EwwV1O0LpmEFaZlb+Nmf0Ec357seUtU4Wd9DrEv8iMBSf5jHu4oXRisPt8xEA==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d80fda9c-182d-401c-52fc-08d841e31b10
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2020 12:51:34.3789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xDUd8mXJezYi4ccGsz8/ti1WiYwScLL8BUK5CxjmTV5drGtg/Tt/zxVxE5EGa7SVhGE8Db6qD/khNuosxYMyNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4347
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/16/20 7:29 AM, Cong Wang wrote:
> __tipc_nl_compat_dumpit() has two callers, and it expects them to
> pass a valid nlmsghdr via arg->data. This header is artificial and
> crafted just for __tipc_nl_compat_dumpit().
> 
> tipc_nl_compat_publ_dump() does so by putting a genlmsghdr as well
> as some nested attribute, TIPC_NLA_SOCK. But the other caller
> tipc_nl_compat_dumpit() does not, this leaves arg->data uninitialized
> on this call path.
> 
> Fix this by just adding a similar nlmsghdr without any payload in
> tipc_nl_compat_dumpit().
> 
> This bug exists since day 1, but the recent commit 6ea67769ff33
> ("net: tipc: prepare attrs in __tipc_nl_compat_dumpit()") makes it
> easier to appear.
> 
> Reported-and-tested-by: syzbot+0e7181deafa7e0b79923@syzkaller.appspotmail.com
> Fixes: d0796d1ef63d ("tipc: convert legacy nl bearer dump to nl compat")
> Cc: Jon Maloy <jmaloy@redhat.com>
> Cc: Ying Xue <ying.xue@windriver.com>
> Cc: Richard Alpe <richard.alpe@ericsson.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Good finding and thanks to fix it!

Acked-by: Ying Xue <ying.xue@windriver.com>

> ---
>  net/tipc/netlink_compat.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/net/tipc/netlink_compat.c b/net/tipc/netlink_compat.c
> index 217516357ef2..90e3c70a91ad 100644
> --- a/net/tipc/netlink_compat.c
> +++ b/net/tipc/netlink_compat.c
> @@ -275,8 +275,9 @@ static int __tipc_nl_compat_dumpit(struct tipc_nl_compat_cmd_dump *cmd,
>  static int tipc_nl_compat_dumpit(struct tipc_nl_compat_cmd_dump *cmd,
>  				 struct tipc_nl_compat_msg *msg)
>  {
> -	int err;
> +	struct nlmsghdr *nlh;
>  	struct sk_buff *arg;
> +	int err;
>  
>  	if (msg->req_type && (!msg->req_size ||
>  			      !TLV_CHECK_TYPE(msg->req, msg->req_type)))
> @@ -305,6 +306,15 @@ static int tipc_nl_compat_dumpit(struct tipc_nl_compat_cmd_dump *cmd,
>  		return -ENOMEM;
>  	}
>  
> +	nlh = nlmsg_put(arg, 0, 0, tipc_genl_family.id, 0, NLM_F_MULTI);
> +	if (!nlh) {
> +		kfree_skb(arg);
> +		kfree_skb(msg->rep);
> +		msg->rep = NULL;
> +		return -EMSGSIZE;
> +	}
> +	nlmsg_end(arg, nlh);
> +
>  	err = __tipc_nl_compat_dumpit(cmd, msg, arg);
>  	if (err) {
>  		kfree_skb(msg->rep);
> 
