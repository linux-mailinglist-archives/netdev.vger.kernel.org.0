Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B58953EACB
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237933AbiFFMyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 08:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237918AbiFFMyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 08:54:11 -0400
X-Greylist: delayed 601 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 06 Jun 2022 05:54:07 PDT
Received: from smtp.uniroma2.it (smtp.uniroma2.it [160.80.6.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52DCB252B8;
        Mon,  6 Jun 2022 05:54:07 -0700 (PDT)
Received: from smtpauth-2019-1.uniroma2.it (smtpauth-2019-1.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 256CXgr7024134;
        Mon, 6 Jun 2022 14:33:47 +0200
Received: from lubuntu-18.04 (unknown [160.80.103.126])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id DFA831212B4;
        Mon,  6 Jun 2022 14:33:38 +0200 (CEST)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1654518819; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8B6BQq7gCMMTyTKJNSZBHuMyyStdALnwUURupL2Td2o=;
        b=X7w1dL/Qdi0cGco1mzCLqfC//5laoY1s1Mcit4m6zobej3fu2+NwBDv9UFWimW+rIlfVnu
        oLBzbUp7cCWCJvBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1654518819; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8B6BQq7gCMMTyTKJNSZBHuMyyStdALnwUURupL2Td2o=;
        b=nz5Ja2R9K87ulc+qvyWNju3i1v8S9IXm1GruSHe1XLogKTdmXH8UY3Sfs4k/t52+iDxB+c
        wj23Fqx0P1hqsZ1l988VEenJPgrYS6dl1fBVUocxgHER8nTlfoOR52HwjapbuDDNutwSyI
        Q7N+sm7olNFUdRjzGD8Oos6kow+yYuUSApFPJlxa/RtegzNgGvkeIsbjBZCv2a5JKBLNqY
        +hN/mRWoa3j8e6OAIqvH/F5Z1rpPexJIbAzAVMzIN/13+EevVnb+5pPM9rBFq7QzhFRLqK
        B73DgcDvU/UpPpAqsQrVMJ2jWs87WuBW+zTfr8eQBkMLkuUlB8NeLOHqh3PF+w==
Date:   Mon, 6 Jun 2022 14:33:38 +0200
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     Anton Makarov <am@3a-alliance.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, david.lebrun@uclouvain.be,
        regressions@lists.linux.dev, stable@vger.kernel.org,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: Re: [REGRESSION] net: SRv6 End.DT6 function is broken in VRF mode
Message-Id: <20220606143338.91df592bbb7dc2f7db4747e6@uniroma2.it>
In-Reply-To: <7e315ff1-e172-16c3-44b5-0c83c4c92779@3a-alliance.com>
References: <7e315ff1-e172-16c3-44b5-0c83c4c92779@3a-alliance.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 Jun 2022 15:23:26 +0300
Anton Makarov <am@3a-alliance.com> wrote:

> #regzbot introduced: b9132c32e01976686efa26252cc246944a0d2cab
> 
> Hi All!
> 
> Seems there is a regression of SRv6 End.DT6 function in VRF mode. In the 
> following scenario packet is decapsulated successfully on vrf10 
> interface but not forwarded to vrf10's slave interface:
> 
> ip netns exec r4 ip -6 nexthop add id 1004 encap seg6local action 
> End.DT6 vrftable 10 dev vrf10
> 
> ip netns exec r4 ip -6 route add fcff:0:4:200:: nhid 1004
> 
> 
> In End.DT6 legacy mode everything works good:
> 
> ip netns exec r4 ip -6 nexthop add id 1004 encap seg6local action 
> End.DT6 table 10 dev vrf10
> 
> ip netns exec r4 ip -6 route add fcff:0:4:200:: nhid 1004
> 
> 
> The issue impacts even stable v5.18.1. Please help to fix it.
> 
> 
> Thanks!
> 
> Anton
> 
> 
> 

Hi Anton,

thank you for reporting this issue. I am already working on a fix patch which I
will send shortly.

Andrea
