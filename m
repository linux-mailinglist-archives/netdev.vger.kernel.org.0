Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 086D26C27A8
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 02:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjCUB6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 21:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjCUB6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 21:58:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A93326C05;
        Mon, 20 Mar 2023 18:58:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2CC6618E3;
        Tue, 21 Mar 2023 01:58:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACDA1C433EF;
        Tue, 21 Mar 2023 01:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679363888;
        bh=uly1b7i/sKEvRzXRdF6lkwk4JmtjRD6wxFf1R53P244=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NIfyFZ62Gp4IgyXUajbRVdgi75FEA7P004gNGrMhrF2iJKOwnk6NXx9q5A7xyj5w1
         vGpTiwvSbJNZ+6lF4xi5HhDVIZhJ3jrhJopEUbb2wlJ0oXyXFONqO7DjtNsc0YuRRQ
         T/jSkXi6LFQ00/2NjjAZhLq8CqmtIY/br7evU64choz7hRl7W9AZUdGkMXNOy4cs0D
         qzjfuHoe6H+2+oNNI9RAk9oi1UtTAh/1Vu9qp3FNRpqO0lBokVJQqUk3gHfM6pz0pT
         g/dkxe6bpKmmjS9bme3yoXVl8xiAOMqUJueyAM648vRZIElbeA8ZMO0H9tTzhBA0Pm
         gbCXqsQ9eCynw==
Date:   Mon, 20 Mar 2023 18:58:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     f.fainelli@gmail.com
Cc:     =?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6?= Rojas <noltari@gmail.com>,
        andrew@lunn.ch, jonas.gorski@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Subject: Re: [PATCH v2] net: dsa: tag_brcm: legacy: fix daisy-chained
 switches
Message-ID: <20230320185806.5dd71c90@kernel.org>
In-Reply-To: <20230319095540.239064-1-noltari@gmail.com>
References: <20230317120815.321871-1-noltari@gmail.com>
        <20230319095540.239064-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 19 Mar 2023 10:55:40 +0100 =C3=81lvaro Fern=C3=A1ndez Rojas wrote:
> When BCM63xx internal switches are connected to switches with a 4-byte
> Broadcom tag, it does not identify the packet as VLAN tagged, so it adds =
one
> based on its PVID (which is likely 0).
> Right now, the packet is received by the BCM63xx internal switch and the =
6-byte
> tag is properly processed. The next step would to decode the corresponding
> 4-byte tag. However, the internal switch adds an invalid VLAN tag after t=
he
> 6-byte tag and the 4-byte tag handling fails.
> In order to fix this we need to remove the invalid VLAN tag after the 6-b=
yte
> tag before passing it to the 4-byte tag decoding.

Is it good to go in, Florian?
