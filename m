Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7491E6C32
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 22:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407104AbgE1UPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 16:15:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:57390 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407089AbgE1UPE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 16:15:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E585EADD3;
        Thu, 28 May 2020 20:15:01 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id C7A2A60347; Thu, 28 May 2020 22:15:01 +0200 (CEST)
Date:   Thu, 28 May 2020 22:15:01 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Ronak Doshi <doshir@vmware.com>,
        Pv-drivers <Pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 2/4] vmxnet3: add support to get/set rx flow
 hash
Message-ID: <20200528201501.q4rta6v2xjxn26ti@lion.mk-sys.cz>
References: <20200528183615.27212-1-doshir@vmware.com>
 <20200528183615.27212-3-doshir@vmware.com>
 <20200528192051.hnqeifcjmfu5vffz@lion.mk-sys.cz>
 <EE27E96B-155D-445E-B205-861B7D516BE1@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EE27E96B-155D-445E-B205-861B7D516BE1@vmware.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 28, 2020 at 07:29:34PM +0000, Ronak Doshi wrote:
> 
> On 5/28/20, 12:21 PM, "Michal Kubecek" <mkubecek@suse.cz> wrote:
> 
> >    On Thu, May 28, 2020 at 11:36:13AM -0700, Ronak Doshi wrote:
> >    > With vmxnet3 version 4, the emulation supports multiqueue(RSS) for
> >    > UDP and ESP traffic. A guest can enable/disable RSS for UDP/ESP over
> >    > IPv4/IPv6 by issuing commands introduced in this patch. ESP ipv6 is
> >    > not yet supported in this patch.
> >    > 
> >    > This patch implements get_rss_hash_opts and set_rss_hash_opts
> >    > methods to allow querying and configuring different Rx flow hash
> >    > configurations.
> >    > 
> >    > Signed-off-by: Ronak Doshi <doshir@vmware.com>
> >    > ---
> >
> >    This still suffers from the inconsistency between get and set handler
> >   I already pointed out in v1:
> >   
> >    - there is no way to change VMXNET3_RSS_FIELDS_TCPIP{4,6} bits
> >    - get_rxnfc() may return value that set_rxnfc() won't accept
> >    - get_rxnfc() may return different value than set_rxnfc() set
> >    
> >    Above, vmxnet3_get_rss_hash_opts() returns 0 or
> >    RXH_L4_B_0_1 | RXH_L4_B_2_3 | RXH_IP_SRC | RXH_IP_DST for any of
> >    {TCP,UDP}_V{4,6}_FLOW, depending on corresponding bit in rss_fields. But
> >    here you accept only all four bits for TCP (both v4 and v6) and either
> >    the two RXH_IP_* bits or all four for UDP.
> >    
> >    Michal
>  
> Hi Michal,
> 
> That is intentional as vmxnet3 device always expects TCP rss to be enabled
> if rss is supported. If RSS is enabled, by default rss_fields has TCP/IP RSS
> supported and cannot be disabled. Its only for UDP/ESP flows the config
> can change. Hence, get_rss always reports TCP/IP RSS enabled, and set_rss
> does not accept disabling TCP RSS. Hope this answers your concern.

Maybe it will be easier to understand what I'm talking about if I show
it in a table. Let's use shortcuts

  L3 = RXH_IP_SRC | RXH_IP_DST
  L4 = RXH_L4_B_0_1 | RXH_L4_B_2_3

Then vmxnet3_get_rss_hash_opts() translates rss_fields bits to
info->data like this:
                             0        1
---------------------------------------------
VMXNET3_RSS_FIELDS_TCPIP4    0        L3 | L4
VMXNET3_RSS_FIELDS_TCPIP6    0        L3 | L4
VMXNET3_RSS_FIELDS_UDPIP4    0        L3 | L4
VMXNET3_RSS_FIELDS_UDPIP6    0        L3 | L4
VMXNET3_RSS_FIELDS_ESPIP4    L3       L3 | L4
VMXNET3_RSS_FIELDS_ESPIP6    L3       L3

But the translation from info->data to bits of rss_fields which should
be the inverse of above, actually works like ("err" means -EINVAL error
and "noop" that nothing is done):

                             0      L3      L3 | L4 
---------------------------------------------------
VMXNET3_RSS_FIELDS_TCPIP4    err    err     noop
VMXNET3_RSS_FIELDS_TCPIP6    err    err     noop
VMXNET3_RSS_FIELDS_UDPIP4    err    0       1
VMXNET3_RSS_FIELDS_UDPIP6    err    0       1
VMXNET3_RSS_FIELDS_ESPIP4    err    0       1
VMXNET3_RSS_FIELDS_ESPIP6    err    noop    err 

This means that for both TCP and UDP, you have cases where get handler
will return value which will cause an error if it's fed back to set
handler. And for UDP, accepted values for set are L3 and L3 | L4 but get
handler returns 0 or L3 | L4.

So UDP part is wrong and if TCP always hashes by all four fields, it
would be cleaner to return that information unconditionally, like you do
e.g. for ESPv6 (with a different value).

Michal
