Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8646E65C7A9
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 20:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234052AbjACTnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 14:43:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233588AbjACTnI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 14:43:08 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DACD13F8A;
        Tue,  3 Jan 2023 11:43:06 -0800 (PST)
Received: from [IPV6:2003:e9:d713:1514:1485:44:32f3:65e5] (p200300e9d71315141485004432f365e5.dip0.t-ipconnect.de [IPv6:2003:e9:d713:1514:1485:44:32f3:65e5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 14E1FC0269;
        Tue,  3 Jan 2023 20:43:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1672774984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NC5q5+dHgjb1KmSSUPPHbJcHM2Vx5vLPqLLg9zWQDBc=;
        b=lOvqhhDo4wXzm9zwysixEA+QmT8I9mcjwYw3St5S2dpM5lbqsX45atPtKnnNhZulsYq7KP
        T/VdIHP4BHtbwgzTqv8l4pxjyJ0PR0Qg6A4GOk2ejrgei6Pph5uVSTfroONIAEVQVhL7fC
        h2mCDaS0qChC9qITX1d06js7Qf+737NVIpgjc3UJKV4GRp4aLuf+1rBDhbtW3oMvy1u3YG
        KIyC09W3E3pKckpwjrBqdjxsMyKgFvou20Chd1zhclCUihD9WwcgH6+TafpH7nmNGcVNGy
        lTXq82ZpDcy6vgkdyBBBu07+cdPHKVcIun9y+8POqDF52LK/fCKh+k0Up663GQ==
Message-ID: <9828444e-d047-40ac-6550-0bde4a9b5230@datenfreihafen.org>
Date:   Tue, 3 Jan 2023 20:43:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH wpan-next v3 0/6] IEEE 802.15.4 passive scan support
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <alex.aring@gmail.com>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
References: <20230103165644.432209-1-miquel.raynal@bootlin.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20230103165644.432209-1-miquel.raynal@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Miquel.

On 03.01.23 17:56, Miquel Raynal wrote:
> Hello,
> 
> We now have the infrastructure to report beacons/PANs, we also have the
> capability to transmit MLME commands synchronously. It is time to use
> these to implement a proper scan implementation.
> 
> There are a few side-changes which are necessary for the soft MAC scan
> implementation to compile/work, but nothing big. The two main changes
> are:
> * The introduction of a user API for managing scans.
> * The soft MAC implementation of a scan.
> 
> In all the past, current and future submissions, David and Romuald from
> Qorvo are credited in various ways (main author, co-author,
> suggested-by) depending of the amount of rework that was involved on
> each patch, reflecting as much as possible the open-source guidelines we
> follow in the kernel. All this effort is made possible thanks to Qorvo
> Inc which is pushing towards a featureful upstream WPAN support.
> 
> Example of output:
> 
> 	# iwpan monitor
> 	coord1 (phy #1): scan started
> 	coord1 (phy #1): beacon received: PAN 0xabcd, addr 0xb2bcc36ac5570abe
> 	coord1 (phy #1): scan finished
> 	coord1 (phy #1): scan started
> 	coord1 (phy #1): scan aborted

These patches have been applied to the wpan-next tree and will be
part of the next pull request to net-next. Thanks!

Before I would add them to a pull request to net-next I would like to 
have an updated patchset for iwpan to reflect these scan changes. We 
would need something to verify the kernel changes and try to coordinate 
a new iwpan release with this functionality with the major kernel 
release bringing the feature.

Thanks again for your work.

regards
Stefan Schmidt
