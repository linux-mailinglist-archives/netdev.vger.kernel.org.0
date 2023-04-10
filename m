Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF2B6DCA8D
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 20:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbjDJSL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 14:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbjDJSLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 14:11:55 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2133.outbound.protection.outlook.com [40.107.244.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0184CF;
        Mon, 10 Apr 2023 11:11:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MPfPJHnMqCpH5Mt7YMKtzbG4XTlhzeIBnV/hNpnNy2dzA3HTkAmYe9Y/IKhwTnxK6LXh6gyG+1N8b0Se2yNF8+bOKUOSbaDwti3wqYJFy9ilp0IsliYTV7cTIUmIsbU3SuJyh2gPlvX26NeCbOZWAX9Dn7HKqqKRAioBdaTK+OVdI/DrlldobLQ8gg6j4HRLrZP3dX1cB8ClIQhqZ31nL+kciEQon18QoOz5Aftq1ogUPKdkWe7cjdZ2z5Wjjn8Xknxj2Ni559fzMn+m5XwaijSHw6D8nUoTokXeOqya/YluuLwhlEXrp02/HZlB7tn0XM5B0aFhebYVTOQ7hli0Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jtf2oEJwma+VI/kKwviJh8GilpjhJ6r2XtBRw/xhcaw=;
 b=hwzu2sdGnUaISlhrq/IMZGAZ7HiizXP7cWoPQ1LSOnsQ+Q44m83t7hLIWu3Y84EpKOsnY+Ye5mD4muBmzBfI6q4z/TTGwQSOp/LQEszZMnrjSL3ZXgk4qj4Aa6V5eqmW8M+Xg77vdWcqfqFUFI5P4Si8vWmdYkPgehhQaNxJxitzgvUU3dwNT+X2YXHVsRxsuN0TQFTLV8pJk8TpFILMe0GSQ/Imb1kUiWQ6ZiVfjteTX7Bik/90RF9gd7183Zx9yLZdrN3ElB3HtTo8DuqHPMSVjX5l9RKq/u10ZKpuxIQBRj3BfnUFh9X1UhKzwXtkTNKtWkKL453ucedCgh+0cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jtf2oEJwma+VI/kKwviJh8GilpjhJ6r2XtBRw/xhcaw=;
 b=F9noO4f6+Bt0vZVJ57E5bb7PTDqLxjmv27KGLDQ8iatu7qdle+74KwvBeyS97N4n8dQwDxSQhNaboVwoSm4+p5bwSAwK85lXEtT2YJdgRevlBlPKif9MK3R6SeITB2wPW4pcVE3mk+dJXtBkdeHKgGZsArNBWksJ/eP/+/R17Gg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5226.namprd13.prod.outlook.com (2603:10b6:208:345::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Mon, 10 Apr
 2023 18:11:53 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.038; Mon, 10 Apr 2023
 18:11:53 +0000
Date:   Mon, 10 Apr 2023 20:11:44 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     "Song, Yoong Siang" <yoong.siang.song@intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "xdp-hints@xdp-project.net" <xdp-hints@xdp-project.net>
Subject: Re: [PATCH net-next 3/4] net: stmmac: add Rx HWTS metadata to XDP
 receive pkt
Message-ID: <ZDRRYCoKxEsNIJ75@corigine.com>
References: <20230410100939.331833-1-yoong.siang.song@intel.com>
 <20230410100939.331833-4-yoong.siang.song@intel.com>
 <ZDQZeSe5OaFlNKso@corigine.com>
 <PH0PR11MB58304A6BD97AB6DEA58067D5D8959@PH0PR11MB5830.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR11MB58304A6BD97AB6DEA58067D5D8959@PH0PR11MB5830.namprd11.prod.outlook.com>
X-ClientProxiedBy: AM0PR02CA0157.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5226:EE_
X-MS-Office365-Filtering-Correlation-Id: b43dbed3-c695-4020-e3a5-08db39ef0fad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IMB6Q/pjaZH7/BsJlIjqT6bzZ8DMBrq5cBNAC7jdQvPDcCSKYsGHhEYfhmd0785U+BvniNwmsTCl80AFLSM4+PSRi0Epgk5dI3p7Ykf7Y+njsBdnBnJvC/8T66QkAcKvsH9/odJiMH/cKUZLqLVD+0YdaPmACpe+JwwR37JR3emnEltIF0n5nyvL7/vj6I/4M2ZPVC+K6QQFSCu7hKzzsRquPZ9hzNYT3WUW/i10Gjeexi91fkpiM40b7lHdBQk1dcrR/XRPFyUKB2cGKDPWkBRfWM8Wo/n9enfA3BMo8v0GdheXuluaFZvjPu37uinn9qpyaZ9BVpWv5NdikW+soqp+egjjHEYgZn0UsxWRQ0rqXBD7HWAjHJH2Z2REQEG0zLZj2msoXRA/Y4TBI8bd+adDwZpkXQjP0vY8L+1ukdVpE3Ze7NT0OqDgUMb/14WmEVUsrbibsV/mNp6GipJtgw/ZESCN49SLKnZtFOLEOR0YWukk9l+6yQr7EfTCEf527Hii6GdOgbABp/RVaHgUxiMfh0zqNmireGD/GN3Kg0b+kcsc/78kc+nFj6UmEuwJlfH/egQhpUECy06zHTtv7hvN8/OjlEgrJ0jvpCLVQSY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(396003)(136003)(39840400004)(346002)(451199021)(478600001)(86362001)(83380400001)(36756003)(38100700002)(2616005)(6486002)(6666004)(2906002)(316002)(6512007)(186003)(54906003)(44832011)(6506007)(7416002)(66476007)(8936002)(8676002)(6916009)(41300700001)(66556008)(5660300002)(66946007)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E0FmmLFkq6ksuy/2VLyboI5W88xxD3Ms1zQzHtz8vPEkODFhA+21gzYg67x9?=
 =?us-ascii?Q?C2G6TKvocfCgE4It7jbRhRrmTWza5bb+jcj9MTew3IPvvEo9pnAtFeCMM9b2?=
 =?us-ascii?Q?uav6Kg8v9THKEDozaC8JQIfAPR/eGrFEbgae8fv18JwUoCr7aYHblIxp/5ds?=
 =?us-ascii?Q?nAh3T5YK87I57ORpvdPOL4IeWPuZPZFr7FI0DhkNfEVjN3ctYib/ef9nICBz?=
 =?us-ascii?Q?ymfu8wCrqyFEGWr7+Bv2UwqFQdogFyJwvIS9++STWKTMVXzn+eDfXcv3gR3T?=
 =?us-ascii?Q?fzGQK2WdeOq57S7lfvIIfB1tJloIJWCuFDsx59ryjUP/MvrGRax1PEUCSNi9?=
 =?us-ascii?Q?7PhURSR5tFe+ethuFtXw6iLLikiWI941WpDD1IkGM2ID56KrNYPcychVaTsz?=
 =?us-ascii?Q?8SndcNOzwro7m3SHC+OR3usu/fOuPn2rsh1rDFMGHaEBhVVLr6CAQSpZ7wBs?=
 =?us-ascii?Q?EHrOkizrVDzJJWGwMdJMu8fuzTvl8rpuuhzyDSv7cZrbUV3FvGhrFZqEyQKV?=
 =?us-ascii?Q?1eIrl+Z8qVOSUA2iLwybEnislAaYVb1r0OLDXC/WwyqfX5bc9y430MfhFsno?=
 =?us-ascii?Q?pCabxxImb/nvsIRy5amJYHYX/6b1lh+ZILXwNi58kLDtJRaFJQq8uNrLYpBU?=
 =?us-ascii?Q?/UVoLS6jn+qL8LSQpC6e0kU2Rg7OR94LPVcxJlH4cckq26QdJOviNAG8LZuG?=
 =?us-ascii?Q?uDLVI9FrqUSk9Syc+zjshvnaxVM7KUJHxPwQBCK3Ewc2uuf9OMTyLbufJ4JO?=
 =?us-ascii?Q?HyQDDlFuTAbPi8mEDjwP3ImQWDscqrSm5neU10Q2Bm2B+FwFr3k3tb3DSLcs?=
 =?us-ascii?Q?l37xuagFFNoKc5iFQUoR49OdjNR/1XxRmskLzSKPe/pMbH9TrnUZ1w+LMxOQ?=
 =?us-ascii?Q?McgSyUG1i9n3fsjlr2uKMz5gIEgjNpVcMRKXBlgHjk708W4ylmCdL7aggGaN?=
 =?us-ascii?Q?2+YQ6Qb6uj+KYazmI+0MQHoFigjeUOKKMd//FzQPuoaB/a4pSVK14nf+m9Nq?=
 =?us-ascii?Q?uGY+86N9eeHX+QiknsEjbOFsxR4bbG5GSmRoVMzero47mmW3FMkbK9AN1D/4?=
 =?us-ascii?Q?zRl2PqHA04jcn8nlNoflfgIdBynhnBRflVL0feY10ILGMxwMUl8r7FRz3IUJ?=
 =?us-ascii?Q?mTd1p2TD6QJQQ3MmcZf1+9NolVUK0P3jvAAcJ/dwKz/bunh84HYl5GBRV8cR?=
 =?us-ascii?Q?rlRopHYWUXn2SWDoJesnXg1EFCi9U9cCAoUFVYSXi5JXbcZ+icA/8eIoIz/q?=
 =?us-ascii?Q?UqbeHG2CJIiCc+R7pjHmM0WTWgNh96vkGy7m3MjgKtt2jPlETyyDtXOtl7Bf?=
 =?us-ascii?Q?1MVTpPxWU0rE6A7hRAf4jGOn35ynpztWR3xljj/cApJfDP4v0WjIYGoTW51B?=
 =?us-ascii?Q?PMld5jSgbCv7mGbVzusnaPtnGnQMxh9xxEW3GwEtaRDXJEnLzVBHfYEriBb/?=
 =?us-ascii?Q?UeKQrVouOxajqGBSXOLXg1DE0MQy5yUZOPC2eir6TwOKDGvw4hX+UUdH+Y3r?=
 =?us-ascii?Q?/INJFiRYjhYfLe1+0gTKAUdgZrUvFhTCZZj+fPQghZybsk7U1MYSTCKIG6VD?=
 =?us-ascii?Q?NZiUOgRlNCDBzME4S8QSXTZdZvOnq3/YkAuzZ0kMxkfY3DDsX1x2eygreTSk?=
 =?us-ascii?Q?0NKV05B/IXOqjp2ROMfrkzSf4AoKK1kmwK4ZBVkRetMdTeyxQFM/O6zJWOzc?=
 =?us-ascii?Q?yyl3/A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b43dbed3-c695-4020-e3a5-08db39ef0fad
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 18:11:52.8897
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BAjDA69q4PVb0B5vyJqnJ+sKxTgA3Y2x8yttHeDqqMuzZxvX4PEBpmYscDqBjtz8msCr7I/Jz+hA46vPMWQ3CSHa8M4IxfJXNTY16NRXpA0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5226
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 10, 2023 at 03:33:48PM +0000, Song, Yoong Siang wrote:
> >On Mon, Apr 10, 2023 at 06:09:38PM +0800, Song Yoong Siang wrote:
> >> Add receive hardware timestamp metadata support via kfunc to XDP
> >> receive packets.
> >>
> >> Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
> >
> >...
> >
> >> @@ -7071,6 +7073,22 @@ void stmmac_fpe_handshake(struct stmmac_priv
> >*priv, bool enable)
> >>  	}
> >>  }
> >>
> >> +static int stmmac_xdp_rx_timestamp(const struct xdp_md *_ctx, u64
> >> +*timestamp) {
> >> +	const struct stmmac_xdp_buff *ctx = (void *)_ctx;
> >> +
> >> +	if (ctx->rx_hwts) {
> >> +		*timestamp = ctx->rx_hwts;
> >> +		return 0;
> >> +	}
> >> +
> >> +	return -ENODATA;
> >> +}
> >> +
> >> +const struct xdp_metadata_ops stmmac_xdp_metadata_ops = {
> >> +	.xmo_rx_timestamp		= stmmac_xdp_rx_timestamp,
> >> +};
> >
> >sparse seems to think this should be static.
> >
> >drivers/net/ethernet/stmicro/stmmac/stmmac_main.c:7082:31: warning: symbol
> >'stmmac_xdp_metadata_ops' was not declared. Should it be static?
> Yes, you are right. It should be static. I will add correct it in v2. Thank you.

Thanks
