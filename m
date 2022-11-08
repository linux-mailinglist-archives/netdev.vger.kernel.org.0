Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6D4620DE7
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 11:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbiKHK5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 05:57:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233982AbiKHK5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 05:57:02 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADE0829CB4;
        Tue,  8 Nov 2022 02:57:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7LZgN1MGzpYB9kQzT0oOgi5SYlCbGt69gduWh0AtukQ=; b=macuIFLkl9VFOW3bU8Hl7xDksA
        1hOxJwylT4ApuyJmgKKPlljl6wuxi+ay9ZY8fNk7AvtC05OrBcmJCAq9Geeh0QZcuzmEJoqt94mfA
        HRG6JLmFro8OpFko+bKdJ8BTnGoPG2QUCLWNC/Uy2G5RPLkpKCZ2pWTPIaUzxQuw0Klk=;
Received: from p200300daa72ee1006d973cebf3767a25.dip0.t-ipconnect.de ([2003:da:a72e:e100:6d97:3ceb:f376:7a25] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1osMHk-000Ui9-N2; Tue, 08 Nov 2022 11:56:52 +0100
Message-ID: <75932a98-0f9b-0cda-c1dc-29322bc0141b@nbd.name>
Date:   Tue, 8 Nov 2022 11:56:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.2
Subject: Re: [PATCH 08/14] net: vlan: remove invalid VLAN protocol warning
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
References: <20221107215745.ascdvnxqrbw4meuv@skbuf>
 <3b275dda-39ac-282d-8a46-d3a95fdfc766@nbd.name>
 <20221108090039.imamht5iyh2bbbnl@skbuf>
 <0948d841-b0eb-8281-455a-92f44586e0c0@nbd.name>
 <20221108094018.6cspe3mkh3hakxpd@skbuf>
 <a9109da1-ba49-d8f4-1315-278e5c890b99@nbd.name>
 <20221108100851.tl5aqhmbc5altdwv@skbuf>
 <5dbfa404-ec02-ac41-8c9b-55f8dfb7800a@nbd.name>
 <20221108103330.xt6wi3x3ugp7bbih@skbuf>
 <1be4d21b-c0a4-e136-ed68-c96470135f14@nbd.name>
 <20221108105237.v4coebbj7kzee7y6@skbuf>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <20221108105237.v4coebbj7kzee7y6@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.11.22 11:52, Vladimir Oltean wrote:
> On Tue, Nov 08, 2022 at 11:42:09AM +0100, Felix Fietkau wrote:
>> Okay, I will stick with METADATA_HW_PORT_MUX for now. If we use it in the
>> flow dissector to avoid the tagger specific fixup, we might as well use it
>> in DSA to skip the tag proto receive call. What do you think?
> 
> I suppose that dsa_switch_rcv() could test for the presence of a metadata_dst
> and treat that generically if present, without unnecessarily calling down into
> the tagging protocol ->rcv() call. The assumption being that the metadata_dst
> is always formatted (by the DSA master) in a vendor-agnostic way.
Right. The assumption is that if we use METADATA_HW_PORT_MUX, the field 
md_dst->u.port_info.port_id will contain the index of the DSA port.

- Felix
