Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC7E66B8F2C
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 11:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbjCNKDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 06:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjCNKDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 06:03:34 -0400
Received: from mail.sgstbr.de (mail.sgstbr.de [IPv6:2a01:4f8:10b:1515::10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D452B24487;
        Tue, 14 Mar 2023 03:03:28 -0700 (PDT)
Received: from [IPV6:2a02:810d:ab40:2500:3b46:4127:c750:bf0] (unknown [IPv6:2a02:810d:ab40:2500:3b46:4127:c750:bf0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: fabian@blaese.de)
        by mail.sgstbr.de (Postfix) with ESMTPSA id 4778C248C26;
        Tue, 14 Mar 2023 10:56:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=blaese.de; s=201803;
        t=1678787772; bh=yWcoB4tVZlJzYKHd4ly9wNaGuCzR7+nWR+G7gkbfJvk=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=pNpDr1rBumEWK7kpBbgQwV6sZSB0iH2Uv//13GnMlr9JVyygjuCd5+TDWJbXpRQvO
         FO05V7qcbyjT1R+UcCdQt1aThhPiVuP0bV2GQEsiFH+LJKqKJFZs+cDVGaYBjltun/
         bGKV9N6qts6w6MSAhHmhPYf+GAQahXVetJSO+mGA/U0XG0LyGiow8PsRVO/1JnVISV
         /SJUQz9ikMDKnvIjEtKyvNzoUOAOcLF5YqQhsaXLfPiYlFebTR+5gRoIjSDChn+jxf
         Nvq2CtOLNW0294X4SoJ/JdgwtyZhfEMLN+KUQZlRgBW54DcJxw9Dmk5EIUvH2a9DO/
         MuFLPed4kheqA==
Message-ID: <cc5883b7-e48e-80a3-8797-eb941405cd17@blaese.de>
Date:   Tue, 14 Mar 2023 10:56:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net v2 1/2] net: stmmac: fix PHY handle parsing
Content-Language: de-DE
To:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Looi Hong Aun <hong.aun.looi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Lai Peter Jun Ann <peter.jun.ann.lai@intel.com>
References: <20230314070208.3703963-1-michael.wei.hong.sit@intel.com>
 <20230314070208.3703963-2-michael.wei.hong.sit@intel.com>
From:   =?UTF-8?Q?Fabian_Bl=c3=a4se?= <fabian@blaese.de>
In-Reply-To: <20230314070208.3703963-2-michael.wei.hong.sit@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14.03.23 08:02, Michael Sit Wei Hong wrote:
> phylink_fwnode_phy_connect returns 0 when set to MLO_AN_INBAND.
> This causes the PHY handle parsing to skip and the PHY will not be attached
> to the MAC.
> 
> Add additional check for PHY handle parsing when set to MLO_AN_INBAND.
> 
> Fixes: ab21cf920928 ("net: stmmac: make mdio register skips PHY scanning for fixed-link")
> Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
> Signed-off-by: Lai Peter Jun Ann <peter.jun.ann.lai@intel.com>

Tested-by: Fabian Bläse <fabian@blaese.de>
