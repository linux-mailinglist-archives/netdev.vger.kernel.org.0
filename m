Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA0E644FD7
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 00:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbiLFXyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 18:54:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiLFXyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 18:54:36 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8E5AB30574
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 15:54:35 -0800 (PST)
Date:   Wed, 7 Dec 2022 00:54:31 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Aaron Conole <aconole@redhat.com>,
        Saeed Mahameed <saeed@kernel.org>
Subject: Re: [PATCHv3 net-next 5/5] net: move the nat function to nf_nat_ovs
 for ovs and tc
Message-ID: <Y4/WNywqOPQlCQrz@salvia>
References: <cover.1670369327.git.lucien.xin@gmail.com>
 <bbaf96445e9e60136dfaacdc58726bfd3a9e5148.1670369327.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <bbaf96445e9e60136dfaacdc58726bfd3a9e5148.1670369327.git.lucien.xin@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 06:31:16PM -0500, Xin Long wrote:
[...]
> diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
> index 1d4db1943936..0976d34b1e5f 100644
> --- a/net/netfilter/Makefile
> +++ b/net/netfilter/Makefile
> @@ -54,6 +54,12 @@ obj-$(CONFIG_NF_CONNTRACK_TFTP) += nf_conntrack_tftp.o
>  
>  nf_nat-y	:= nf_nat_core.o nf_nat_proto.o nf_nat_helper.o
>  
> +ifdef CONFIG_OPENVSWITCH
> +nf_nat-y += nf_nat_ovs.o
> +else ifdef CONFIG_NET_ACT_CT
> +nf_nat-y += nf_nat_ovs.o
> +endif

Maybe add CONFIG_NF_NAT_OVS and select it from OPENVSWITCH Kconfig
(select is a hammer, but it should be fine in this case since
OPENVSWITCH already depends on NF_NAT?).

Then in Makefile:

nf_nat-$(CONFIG_NF_NAT_OVS)  += nf_nat_ovs.o

And CONFIG_NF_NAT_OVS depends on OPENVSWITCH.

>  obj-$(CONFIG_NF_LOG_SYSLOG) += nf_log_syslog.o
>  
>  obj-$(CONFIG_NF_NAT) += nf_nat.o
