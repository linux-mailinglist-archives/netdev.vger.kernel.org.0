Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACEC26AD17E
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 23:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjCFW1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 17:27:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjCFW1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 17:27:53 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE456512F;
        Mon,  6 Mar 2023 14:27:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
        bh=BGzXDnZx8+mCiNisS7Atnv9YnItWYP7gOAI+eGw+fp4=; b=LHJUnwT4DDHLVtqbSLfhcjfqAd
        h1Sb2hRVLRJwRKL7UvggVIR73cnirt6/P1g3KkiRuCZlYtPTE1FQu8QUIOQy0LZIr9qiSYDsZ3cmv
        LNhRjvV3eutlrr+jfJg31K3q6RzcjzX7BrU2p0VQfU1SGNpZ1pSf8Kt+hwOFtezn3xdc66k7q7Vj6
        TnNC/Uo6yUOdJpJfLnE6seHsTWzdtprcOtSjMphW5H5ytXyDud5MeIXg4LUqgfkR6QtMsReejHrtz
        DZW0jGR1EOicCRONfb6Wi+9hz1iRgpA6JirmrqMHOZ+3PRRh3Oh2eSLZ4v0mRgtaOcJcbaWkG/3FD
        dl2mjKKg==;
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1pZJIz-000C1l-PO; Mon, 06 Mar 2023 23:27:41 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1pZJIz-000Mas-Dp; Mon, 06 Mar 2023 23:27:41 +0100
Subject: Re: [PATCH bpf v6] bpf, test_run: fix &xdp_frame misplacement for
 LIVE_FRAMES
To:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230224163607.2994755-1-aleksander.lobakin@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d0c5d435-2e56-f5af-8153-c3a7240f634f@iogearbox.net>
Date:   Mon, 6 Mar 2023 23:27:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20230224163607.2994755-1-aleksander.lobakin@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/26833/Mon Mar  6 09:22:59 2023)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/24/23 5:36 PM, Alexander Lobakin wrote:
> &xdp_buff and &xdp_frame are bound in a way that
> 
> xdp_buff->data_hard_start == xdp_frame
> 
> It's always the case and e.g. xdp_convert_buff_to_frame() relies on
> this.
[...]

The patch got applied to bpf, thanks!
