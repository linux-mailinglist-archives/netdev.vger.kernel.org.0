Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9BA55F65E4
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 14:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbiJFMYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 08:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiJFMYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 08:24:21 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAEE79C2C0;
        Thu,  6 Oct 2022 05:24:19 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id A97F418844A7;
        Thu,  6 Oct 2022 12:24:17 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 9148025001FA;
        Thu,  6 Oct 2022 12:24:17 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id 7014B9EC0005; Thu,  6 Oct 2022 12:24:17 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Thu, 06 Oct 2022 14:24:17 +0200
From:   netdev@kapio-technology.com
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v6 net-next 8/9] net: dsa: mv88e6xxx: add blackhole ATU
 entries
In-Reply-To: <20220928150256.115248-9-netdev@kapio-technology.com>
References: <20220928150256.115248-1-netdev@kapio-technology.com>
 <20220928150256.115248-9-netdev@kapio-technology.com>
User-Agent: Gigahost Webmail
Message-ID: <b5cdf29e7b5a5f7fa4ab1df4c5fd6e62@kapio-technology.com>
X-Sender: netdev@kapio-technology.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-09-28 17:02, Hans Schultz wrote:
> From: "Hans J. Schultz" <netdev@kapio-technology.com>
> 
> Blackhole FDB entries can now be added, deleted or replaced in the
> driver ATU.
> 
> Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 78 ++++++++++++++++++++++++++++++--
>  1 file changed, 74 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c 
> b/drivers/net/dsa/mv88e6xxx/chip.c
> index 71843fe87f77..a17f30e5d4a6 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -2735,6 +2735,72 @@ static int mv88e6xxx_vlan_msti_set(struct 
> dsa_switch *ds,
>  	return err;
>  }
> 
> +struct mv88e6xxx_vid_search_ctx {
> +	u16 vid_search;
> +	u16 fid_found;
> +};
> +
> +static int mv88e6xxx_find_fid_on_matching_vid(struct mv88e6xxx_chip 
> *chip,
> +					      const struct mv88e6xxx_vtu_entry *entry,
> +					      void *priv)
> +{
> +	struct mv88e6xxx_vid_search_ctx *ctx = priv;
> +

FYI: I have already made updates to this part to use mv88e6xxx_vtu_get() 
instead of the walk, which also fixes a problem when vid=0 in this 
implementation.
