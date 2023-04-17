Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F45A6E4A57
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 15:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbjDQNvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 09:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbjDQNu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 09:50:59 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C14FB1BE2;
        Mon, 17 Apr 2023 06:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
        bh=tQUljB+3qJ5JF7D2gbAzZEnYsMvLfH193Z9TzvMq+Dw=; b=CPV8vWuepr3QKQbO2TsvXrRdeH
        Ziz8KW3r+tNy4A1WF6ZuacPdganhAM5Ln+acX2dZmoG0egvVsKYNeLp0pm6xNZOtXIhdHGG5ue0bX
        XIkYzOAfDMpdNwdcZjmY4nxbYAD7pa5gKnvlHqWd/6wE59dh+oPh88Rd6moDQkcR9ko4k3ocXDtnf
        +pP/iFZ3ep6dF2lPuC1OmyhizLX0s4dUOl6eVX+fxu/KLi65ic/oy4c+XWQbi/8OGV+oyBkoPrN6f
        544+peb2XvjWcsV6/Fq7gdyK9IXGJxW89A3RWQMkytQ/La7ZwhNdhJtqdWa1bXVf/f7d0/0A0mDzu
        gSehMDag==;
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1poPFs-000FpM-HI; Mon, 17 Apr 2023 15:50:52 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1poPFs-000Lto-1E; Mon, 17 Apr 2023 15:50:52 +0200
Subject: Re: [PATCH net-next] bpf, net: Support redirecting to ifb with bpf
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Yafang Shao <laoar.shao@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ast@kernel.org, hawk@kernel.org, john.fastabend@gmail.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>, martin.lau@linux.dev
References: <20230413025350.79809-1-laoar.shao@gmail.com>
 <968ea56a-301a-45c5-3946-497401eb95b5@iogearbox.net> <874jpj2682.fsf@toke.dk>
 <ee52c2e4-4199-da40-8e86-57ef4085c968@iogearbox.net> <875y9yzbuy.fsf@toke.dk>
 <c68bf723-3406-d177-49b4-6d5b485048de@iogearbox.net> <87o7npxn1p.fsf@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <53a3b2e0-7d78-ab60-fc18-209148744cf7@iogearbox.net>
Date:   Mon, 17 Apr 2023 15:50:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <87o7npxn1p.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26878/Mon Apr 17 09:23:32 2023)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/15/23 4:00 PM, Toke Høiland-Jørgensen wrote:
> Daniel Borkmann <daniel@iogearbox.net> writes:
> 
>> On 4/14/23 6:07 PM, Toke Høiland-Jørgensen wrote:
>>> Daniel Borkmann <daniel@iogearbox.net> writes:
>> [...]
>>> https://git.openwrt.org/?p=project/qosify.git;a=blob;f=README
>>
>> Thanks for the explanation, that sounds reasonable and this should ideally
>> be part of the commit msg! Yafang, Toke, how about we craft it the following
>> way then to support this case:
> 
> SGTM! With the kbot complaint fixed:

Sounds good, thanks both; sent out now.
