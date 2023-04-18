Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 808906E5F22
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 12:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbjDRKtB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 18 Apr 2023 06:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbjDRKsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 06:48:39 -0400
Received: from us-smtp-delivery-44.mimecast.com (unknown [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63ACC421B
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 03:48:36 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-137-HMs8CwXTMtO7vJUWSLxAIQ-1; Tue, 18 Apr 2023 06:48:17 -0400
X-MC-Unique: HMs8CwXTMtO7vJUWSLxAIQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC5F8185A790;
        Tue, 18 Apr 2023 10:48:16 +0000 (UTC)
Received: from hog (unknown [10.45.225.92])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1A8D32A68;
        Tue, 18 Apr 2023 10:48:14 +0000 (UTC)
Date:   Tue, 18 Apr 2023 12:48:13 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Cc:     "ehakim@nvidia.com" <ehakim@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Naveen Mamindlapalli <naveenm@marvell.com>, atenart@kernel.org
Subject: Re: [PATCH net-next v5 5/5] macsec: Don't rely solely on the dst MAC
 address to identify destination MACsec device
Message-ID: <ZD51bbwHzYGxL3F3@hog>
References: <20230413105622.32697-6-ehakim@nvidia.com>
 <CO1PR18MB4666A6E343DBB5A1CCD005D4A1999@CO1PR18MB4666.namprd18.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <CO1PR18MB4666A6E343DBB5A1CCD005D4A1999@CO1PR18MB4666.namprd18.prod.outlook.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,PDS_BTC_ID,
        PDS_BTC_MSGID,RCVD_IN_DNSWL_LOW,RDNS_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2023-04-14, 06:32:28 +0000, Subbaraya Sundeep Bhatta wrote:
> Hi,
> 
> >-----Original Message-----
> >From: Emeel Hakim <ehakim@nvidia.com> <ehakim@nvidia.com>
> >Sent: Thursday, April 13, 2023 4:26 PM
> >To: davem@davemloft.net; kuba@kernel.org; pabeni@redhat.com;
> >edumazet@google.com; sd@queasysnail.net
> >Cc: netdev@vger.kernel.org; leon@kernel.org; Emeel Hakim
> ><ehakim@nvidia.com>
> >Subject: [PATCH net-next v5 5/5] macsec: Don't rely solely on the dst MAC
> >address to identify destination MACsec device
> >
> >Offloading device drivers will mark offloaded MACsec SKBs with the
> >corresponding SCI in the skb_metadata_dst so the macsec rx handler will know to
> >which interface to divert those skbs, in case of a marked skb and a mismatch on
> >the dst MAC address, divert the skb to the macsec net_device where the macsec
> >rx_handler will be called to consider cases where relying solely on the dst MAC
> >address is insufficient.
> >
> >One such instance is when using MACsec with a VLAN as an inner header, where
> >the packet structure is ETHERNET | SECTAG | VLAN.
> >In such a scenario, the dst MAC address in the ethernet header will correspond to
> >the VLAN MAC address, resulting in a mismatch.
> >
> 
> I did below commands:
> ifconfig eth2 up
> ip link add link eth2 macsec0 type macsec sci cacbcd4142430002
> ifconfig macsec0 hw ether ca:cb:cd:41:42:43
> ip macsec offload macsec0 mac
> ifconfig macsec0 up
> ip macsec add macsec0 tx sa 0 on pn 5 key 02 22222222222222222222222222222222
> ip macsec add macsec0 rx sci cacbcd2122230001
> ip macsec add macsec0 rx sci cacbcd2122230001 sa 0 pn 5 on key 01 11111111111111111111111111111111
> ip link add link macsec0 vlan0 type vlan id 2
> 
> ifconfig vlan0 hw ether ca:cb:cd:21:22:23
> ifconfig vlan0 up
> [ 7106.072451] device macsec0 entered promiscuous mode
> [ 7106.077330] device eth2 entered promiscuous mode
> 
> macsec0 entered promisc mode when upper_dev mac address is not equal to its mac.
> I think we should check if macsec device is in promisc mode instead of omitting mac address compare.
> Also all drivers/hardware do not support md_dst->type == METADATA_MACSEC 

Is there a good reason to not make all drivers use metadata? It seems
to me it would be cleaner than trying to guess where a packet belongs
once it reaches the macsec core.

-- 
Sabrina

