Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 091294FC910
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 02:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236437AbiDLAKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 20:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235884AbiDLAKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 20:10:20 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70078.outbound.protection.outlook.com [40.107.7.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D330C19290
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 17:08:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OwR0uwVXo5BBJGVrwrDMviJwjT1uDuSQ61SzePvavfEQztniIhGaEH6CW3lW6RHaC6UeQW/5x6D1lJ3iVLz/WLeS4KoPdOJal91V+EFVY9EFgXjRMdhxgecdW9w3Cfjjit+7CeYAUo+rgwn/ARWO0rwoKqancXEumxzPN3cwVuiHpk+s/T99lRY/+n/NEw2UDcqwdCWBwD6UFXiTqG3kTZx8tFnz07dcG1nyeOJhcZfREpqrRzjiP1moitR8Ot8vZhCKgc4HcnzrIIcnJL6Jeazs8yYpx91FDAOrKq40qWGSDzQoW+DqL4w3plo2HIRygFoYfee6XGk2OlyjxtP+ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bUEZITritCgIkujhkrDiz/mc+Xxsph5a1kFsdiV73EU=;
 b=KNTY/z6zl/TUr/sjodm4IumpcW+wJkg2sK8fWhZN8ING3kJV0KwM3CPx1rJMpQx/7pgf6W5AwiwoMs+tCZ3eU2311ug/nPMF12CZC289RTPk4x/J4xPYP5amgLgNJzaDN7NGPmMNsWq8dcUvaATFei5behARC0EfFioxnVjCmP8t3/CTZRSue0S+SG4PEpzslfybfSOcIDGMzNWGe1VGXb5QeAv64JEESpP9vBy6ihPNHXxNej9A6U5Y20WwzjjOWu0AsHxCA3q2JL1mMUNaMw8mcXVlBo2XvuGslUchZrcBiREvavH4CqH4VVr07QzvdC/YnZc2vkILaASFR5q3jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bUEZITritCgIkujhkrDiz/mc+Xxsph5a1kFsdiV73EU=;
 b=RNIxuIknQM6W/k3bhTq/SQ2ydMcMuDb+ERsNGAKRnMEHHzMFHNnNqGJsPVWYea0msfPxMaOgXzkAm7u0Sne7RfdOXOrI/hYjVFj5/S/Huww6tCyFvP64nuEtP0zBm7BFgmeWG6JdwA9ZbgAn0VK8uWpDMeesAQ1nLSU6Gi/hNbY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PA4PR04MB7888.eurprd04.prod.outlook.com (2603:10a6:102:b9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 00:08:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5144.029; Tue, 12 Apr 2022
 00:08:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "kuba@kernel.org" <kuba@kernel.org>, Po Liu <po.liu@nxp.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>
Subject: Re: [PATCH net-next v4 02/12] taprio: Add support for frame
 preemption offload
Thread-Topic: [PATCH net-next v4 02/12] taprio: Add support for frame
 preemption offload
Thread-Index: AQHXaiLuC1gW4iDox0yz7Q8gS7SibKsoSU8AgcTa1YCAAApSgA==
Date:   Tue, 12 Apr 2022 00:08:00 +0000
Message-ID: <20220412000759.wtsebxkayb5vssvx@skbuf>
References: <20210626003314.3159402-1-vinicius.gomes@intel.com>
 <20210626003314.3159402-3-vinicius.gomes@intel.com>
 <20210627195826.fax7l4hd2itze4pi@skbuf> <874k2zdwp4.fsf@intel.com>
In-Reply-To: <874k2zdwp4.fsf@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bff06c52-9251-491e-a7ba-08da1c188162
x-ms-traffictypediagnostic: PA4PR04MB7888:EE_
x-microsoft-antispam-prvs: <PA4PR04MB7888AA70E37F3585BD53C87DE0ED9@PA4PR04MB7888.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CVMd8p71CX4PVzzkDDM4pwaEQQ3OBRG95+6wDlkTPNSwUC88MSiYhxgUOX9N7mqCZvoaxibccQSvwnKX7nWWcbvY0WZMsx76S1oJ1K5vZmOH+t13fsBNmw/YQALbWoMVmhLctbvePs6rVavv5bpkjVGedJHUUgnfzhHm+MoUL9wyoo3C4qWPfcUvGc10GuIuG8XTNmGqx4QSu/Waw4e6xs4svxaBog4LwDu0Bho1HsioKvKuRVP9WiD3GZa0NmqUM6g5A066+tiT5WQz+kA3pQ0Oc9aTwAheQyes5bTntHZJUwxrQ8POCSbH/4Mq0uSfSttGe6TtueFnZzErol3d3WdIVMM5fGOhqOIWxsCVKpJE8uqq/AXeRM3uoANl+lAT4JjOWU/aEGpa4itYvv/7gHV9sM2zSB7OMa2n59yDE5YIqHX2oi+Eo0NLZf0wJmrQi7+VxaLJp6DRXMkMSgrrvJktTaCLDZS2PKpYBtIt+YVLcLHn99iBHcw33FCVujlHAbG1zVRK4klRj909YA0AUDY/qMV+YW36ZVvfENf4yvEHepdANw91+1e1kkrx+8O+srB+bjjnydu/mNvvXd9lIilFUdp9V0kTQZavA5y9SQWURbD7h2CXZfXhNUP7c0DVv5uZ2WQBabMyYhBhyFAkNrDqgXDqlpGAzYbJEoGa3RIWxG3j300cZULuMhQwM9psTra0wMgEZ3/rA2IpxoSJMw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(508600001)(76116006)(6916009)(54906003)(316002)(86362001)(71200400001)(6486002)(6506007)(38070700005)(38100700002)(122000001)(83380400001)(6512007)(9686003)(33716001)(1076003)(2906002)(44832011)(5660300002)(66556008)(186003)(26005)(4326008)(8936002)(66946007)(8676002)(64756008)(66476007)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Hkd3nrD9CNCJpDQ9ujUnIKrc5LoOfbV2eAIbP5pH/4DNUy/AbLSSZKb0tagQ?=
 =?us-ascii?Q?ljgOv4nBXejBJ3NMAZXmVAtUGufeQs8kWv8AHvHvUrEuyfA2sySp2MYUHiVP?=
 =?us-ascii?Q?JKNx9J00SxgZoerAeKCRPy6qVrT54NmOAyT++xhmT2X9HnmybUmPp3D1BD8K?=
 =?us-ascii?Q?h2aaQ9P5zVpxoFC1bxUtw7hcw2/RiggaCIoslZJKxKf8LZVXO0tjrabVfe0A?=
 =?us-ascii?Q?qrocpPjfCY0jjuewy5JShSvjrLfv9FRYePrRzAyHBEKIo5xEEXyH7OdiPFqm?=
 =?us-ascii?Q?TT3tWbWWjVZEk7E7ZVq352v6IHVZ01vkDAMM4vBfXsJnqPMJWB32sq8GzpAN?=
 =?us-ascii?Q?w6N6Tjr+b6d5r4aszJRj7DE4nbXfMNH7koIegKsDuQfjBTJ43fj7vbS+hwPK?=
 =?us-ascii?Q?7CVhfGnk+4kK7v7VrPNNSUG0q2JLAyNNrTf3iL7+BT1sb7NioZKE5u9+TEFH?=
 =?us-ascii?Q?LTdS4gbcMSBzh+Q+jFrYIFnITnHjDGxGL4C/YSyIMahG98LKBIJMuXnTxF7j?=
 =?us-ascii?Q?5jUSwUD3Yl8sCgTLViYakLGyDooJNa0llsE+RshbbF36QIb4JaFdja8Tsu60?=
 =?us-ascii?Q?hoCba00wcPvJ8tkgkl0LkmUGWyYoCUMhSAYuwrrTmyXCT8MZqWsuOwqJTO4F?=
 =?us-ascii?Q?T6QShc4XxGTjMRxyOwTn9CxNpbpy4rTGYRiQ3cy11Tb1DpCqWJ8FtehrR8we?=
 =?us-ascii?Q?RXqQ97wupUPazDpZ/hjvfBP3G6nt3+vwahTlYR6VBBSdKThN8FAwDX5Sv9t4?=
 =?us-ascii?Q?/8h/++9NC5YkFR/nqASD8OO1O5gEr/+hWDlZ/AaOdWzDFtieQojJz+jBA3Re?=
 =?us-ascii?Q?r30vqLGIzKOxcsZNQSlBVYn8ONwAi90iCU2wOK0aTHZVGNvL46SdWiotfxai?=
 =?us-ascii?Q?rUF9N+KpbeNrxD1FVscwTMNYpF1YveoQ9SSuFrcQ/TRnTlKAj0lN8tGy3IeE?=
 =?us-ascii?Q?u/pjh3fmJ8RKDoGLJCKB76lU5dX8FCgmzlRtAzMNZX0Y0GlMDDTo/fqAma9W?=
 =?us-ascii?Q?Zw4gZIkGcuoasFWdkfItVw6sRTV2uGj6pNGad5FsaroxXScNZnmj+VhFysXz?=
 =?us-ascii?Q?Cartc4ZuiJgvbHKCD4fXWUCxkYJ/ttjt7ELOQ48pfUXdIrE/wC2xojzQs2/O?=
 =?us-ascii?Q?oOJdhr2l97AYLyemP6zK8fdGEQ14493RhA9QBa5XIveHuG/W/Hi1bghEOeaj?=
 =?us-ascii?Q?+CX6P9JYP7p+uPYs0ySL/K7CjVNOqv4q/vCCt6SQ5tD7vlsD8fGGi6QcODKK?=
 =?us-ascii?Q?dqNp26pg/ADFLfosAAq2LEdNnaX98ezFZYsGQVKrZbnlpW6XYvybSZIYpy8Q?=
 =?us-ascii?Q?uSk9+a8Dn06mcWQo2X6bfMrZVfNijMpjY/TVTTRCBlwfuqYTCV71XOlOXB3o?=
 =?us-ascii?Q?OkiCjMERguL4pB2vZwfUkexp18GJuotORy9+mbgJOuOjz2IV8PdJkS/DLnhl?=
 =?us-ascii?Q?oPOUsPznqAR3iS1/VZmQBfoFgJ1SMcnyp1nYpP9n9hIELzU89aSwFVI3RrpA?=
 =?us-ascii?Q?9zO44Ol8+eZknemPVxN/aMjMNq/b7GpU9CqJzkYoXycMbpLM1HFHqLBv9WN6?=
 =?us-ascii?Q?rytG7t/fRX01hL83S5lkghwvGb25nq2MFmaZ75/ek4fyS+JaJTdIt++M4CKx?=
 =?us-ascii?Q?4Tqe97yDPb/WQX8WUWqQy/CquOEfbwOttXHngvz8wE4OoVis/GiUMuDAFi2Z?=
 =?us-ascii?Q?eOWgcNNP2ZVem/LLspTEzhqa1up2CbH77touDYcxZN10W8reNlvhOSALD/sY?=
 =?us-ascii?Q?VXa1BJgC//Pexj9FHCVKOVrumuVd1WI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <19787BA8D128374CB6C638BB58A0DE7F@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bff06c52-9251-491e-a7ba-08da1c188162
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2022 00:08:00.0459
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gah86DQgREPNq+gGIaM8yG1xhz/MQqTbtfh5nZqrSK4Oe7uPmJCDqv8KgVrMujd+ub5+9Cbqq5m+HqzG6/Elbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7888
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 11, 2022 at 04:31:03PM -0700, Vinicius Costa Gomes wrote:
> > First line in taprio_disable_offload() is:
> >
> > 	if (!FULL_OFFLOAD_IS_ENABLED(q->flags))
> > 		return 0;
> >
> > but you said it yourself below that the preemptible queues thing is
> > independent of whether you have taprio offload or not (or taprio at
> > all). So the queues will never be reset back to the eMAC if you don't
> > use full offload (yes, this includes txtime offload too). In fact, it's
> > so independent, that I don't even know why we add them to taprio in the
> > first place :)
>
> That I didn't change taprio_disable_offload() was a mistake caused in
> part by the limitations of the hardware I have (I cannot have txtime
> offload and frame preemption enabled at the same time), so I didn't
> catch that.
>
> > I think the argument had to do with the hold/advance commands (other
> > frame preemption stuff that's already in taprio), but those are really
> > special and only to be used in the Qbv+Qbu combination, but the pMAC
> > traffic classes? I don't know... Honestly I thought that me asking to
> > see preemptible queues implemented for mqprio as well was going to
> > discourage you, but oh well...
>
> Now, the real important part, if this should be communicated to the
> driver via taprio or via ethtool/netlink.
>
> I don't really have strong opinions on this anymore, the two options are
> viable/possible.
>
> This is going to be a niche feature, agreed, so thinking that going with
> the one that gives the user more flexibility perhaps is best, i.e. using
> ethtool/netlink to communicate which queues should be marked as
> preemptible or express.

So we're back at this, very well.

I was just happening to be looking at clause 36 of 802.1Q (Priority Flow Co=
ntrol),
a feature exchanged through DCBX where flows of a certain priority can be
configured as lossless on a port, and generate PAUSE frames. This is essent=
ially
the extension of 802.3 annex 31B MAC Control PAUSE operation with the abili=
ty to
enable/disable flow control on a per-priority basis.

The priority in PFC (essentially synonymous with "traffic class") is the sa=
me
priority as the priority in frame preemption. And you know how PFC is confi=
gured
in Linux? Not through the qdisc, but through DCB_ATTR_PFC_CFG, a nested dcb=
nl
netlink attribute with one nested u8 attribute per priority value
(DCB_PFC_UP_ATTR_0 to DCB_PFC_UP_ATTR_7).

Not saying we should follow the exact same model as PFC, just saying that I=
'm
hard pressed to find a good reason why the "preemptable traffic classes"
information should sit in a layer which is basically independent of the fra=
me
preemption feature itself.=
