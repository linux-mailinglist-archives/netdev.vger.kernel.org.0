Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00A296BDAAC
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 22:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbjCPVO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 17:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjCPVO0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 17:14:26 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B47496F37;
        Thu, 16 Mar 2023 14:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
        bh=Kw3gyhHeP4st5bWIhkd2RwQ5/1rzrwMt+TeeXEDeMPw=; b=Npp2iFEQVeeP4AYeZvxiPCuurN
        zC+UkLsNqv+rJy6h1e/dgvqpNl206FYUIzxLUo/icVYaDwA3aLAWYq9d8uXheeH2fwW5HbZm5ko3z
        E+37KWTWOIU3eIVjSyJW/qeVZQSA+o5VCQptoxdEYJZqNCBcNFTXE0F/Zk9/ZPmlDBw8ppW+Yvjne
        +Vwgr2vXD++jzuwDvXtZ3yqbXRtKrjasrCcvCOPi3lO0W+mTP4zclpgpXq5xT0LnI9xqjmd53DTLU
        pYi3WBYYTrVoHz4kaj4mUCHdq2C8qJvPR+UKaw9FQVgSe2jQ0QZ2uhfFfbB2Wfu818Z7STLhlCNLA
        xHn+zoLg==;
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1pcuvA-000O8K-VP; Thu, 16 Mar 2023 22:14:00 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1pcuvA-000UM8-D5; Thu, 16 Mar 2023 22:14:00 +0100
Subject: Re: [PATCH bpf v3] xsk: Add missing overflow check in xdp_umem_reg
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        Kal Conley <kal.conley@dectris.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230308174013.1114745-1-kal.conley@dectris.com>
 <CAJ8uoz1f1RSWtFspPQsEBoH_j3=jUYkDmye3nHRQ_xvgHiusHg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <8a076362-c98e-9268-47bd-91f5f8e57449@iogearbox.net>
Date:   Thu, 16 Mar 2023 22:13:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAJ8uoz1f1RSWtFspPQsEBoH_j3=jUYkDmye3nHRQ_xvgHiusHg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26845/Thu Mar 16 19:16:15 2023)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/16/23 1:52 PM, Magnus Karlsson wrote:
> On Wed, 8 Mar 2023 at 18:51, Kal Conley <kal.conley@dectris.com> wrote:
>>
>> The number of chunks can overflow u32. Make sure to return -EINVAL on
>> overflow.
>>
>> Also remove a redundant u32 cast assigning umem->npgs.
> 
> Thanks!
> 
> Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
> 
>> Fixes: bbff2f321a86 ("xsk: new descriptor addressing scheme")
>> Signed-off-by: Kal Conley <kal.conley@dectris.com>

Looks like patchbot was on partial strike, this was applied to bpf, thanks!
