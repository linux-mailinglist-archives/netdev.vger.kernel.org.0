Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D08476D3656
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 10:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbjDBIi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 04:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjDBIiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 04:38:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 231E211D
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 01:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680424657;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i924t6g/U8Sz5oZNi8eHpwH9+wgHgEL8rUIeN7Yevhk=;
        b=eeYaqUv8N3TVdc6WHbiEqDq9YegCHTUXEvsWbIKD9m2zR8GMJGUIJAiW+QQc1xlpTnZm3A
        VvQO0sZJ2O8z6VqUFiGYgVGCoC62Xm61LqFTdaYwtOyGor4RGOWjEH3Jb1mz+ErjUoHuqo
        PSjQ+5HSwWhPR77P43blndAoXF1lzLE=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-367-L4kRUq1POkWNLK5pwNdXNw-1; Sun, 02 Apr 2023 04:37:36 -0400
X-MC-Unique: L4kRUq1POkWNLK5pwNdXNw-1
Received: by mail-lf1-f70.google.com with SMTP id b11-20020a19670b000000b004e9b307b224so10293390lfc.7
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 01:37:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680424654;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i924t6g/U8Sz5oZNi8eHpwH9+wgHgEL8rUIeN7Yevhk=;
        b=AAP7TxsxtU7d3Kkv69tBU0WfY8Ja5t7prcP7m/d773npzzlzPibxej7nDjigWMOAzD
         dcr9U8ruwcKbmOutUmz2qM/Vpb7YK4pMaI8pQdNewr43SIXWYbzyUeEqeaDOnJIZVbWV
         aDImDN+rjTUp9lfr36qRChFJwOWx7RD4znUaKMJOvyLiLZAfATYqaTtBy6w83Zz81Ieh
         D2HvrQoZ19IKJpNAsUETfG0xgdF5/eoCtytxBSqVzaYKR2BwBWxHycIFA4JMMEQf7Wqg
         HuDOS4HYcQC4jniXFN+CWawOJbq5oKdNZOf0SNHZWp5dalq+iXJ7VfWwzgc8zBt61IPv
         wvVg==
X-Gm-Message-State: AAQBX9chly2QzaF8Dgmk4GepkDm3OeEJ4r8aQImZWBpUlxAKJ9hJXDOJ
        xZNGSq+ofeQn7TNmjTPsJ7uAQV9bCH/TealfgsIGAFZ1rtUsGpBl8gpPn+R6rOwwLIdu/lqLOqe
        IkdMtVOHjlpDR9zH4DBXXOopz
X-Received: by 2002:a19:7613:0:b0:4db:3e56:55c8 with SMTP id c19-20020a197613000000b004db3e5655c8mr9495423lff.59.1680424654641;
        Sun, 02 Apr 2023 01:37:34 -0700 (PDT)
X-Google-Smtp-Source: AKy350YT4NdKfptHbUEwzqYe1WUNC6ROtPlFgUhwZhzhr8UJaaCb11s1bFmgFwrE8lhNBuBu1uo19g==
X-Received: by 2002:a19:7613:0:b0:4db:3e56:55c8 with SMTP id c19-20020a197613000000b004db3e5655c8mr9495407lff.59.1680424654319;
        Sun, 02 Apr 2023 01:37:34 -0700 (PDT)
Received: from [192.168.42.100] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id j18-20020a19f512000000b004eb2eb63144sm1114728lfb.120.2023.04.02.01.37.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Apr 2023 01:37:33 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <df64f630-93e6-1ec3-83bc-4584f2856acb@redhat.com>
Date:   Sun, 2 Apr 2023 10:37:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, martin.lau@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexandr.lobakin@intel.com,
        larysa.zaremba@intel.com, xdp-hints@xdp-project.net,
        anthony.l.nguyen@intel.com, yoong.siang.song@intel.com,
        boon.leong.ong@intel.com, intel-wired-lan@lists.osuosl.org,
        pabeni@redhat.com, jesse.brandeburg@intel.com, kuba@kernel.org,
        edumazet@google.com, john.fastabend@gmail.com, hawk@kernel.org,
        davem@davemloft.net, tariqt@nvidia.com
Subject: Re: [PATCH bpf V5 0/5] XDP-hints: API change for RX-hash kfunc
 bpf_xdp_metadata_rx_hash
Content-Language: en-US
To:     bpf@vger.kernel.org, Stanislav Fomichev <sdf@google.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
References: <168028882260.4030852.1100965689789226162.stgit@firesoul>
 <d4b3a22a-c815-a337-29b1-737efd9a7494@redhat.com>
In-Reply-To: <d4b3a22a-c815-a337-29b1-737efd9a7494@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 01/04/2023 18.47, Jesper Dangaard Brouer wrote:
> 
> Why have this patchset[1] been marked "Changes Requested" ?
> 
> Notice: The BPF test_progs are failing on "xdp_do_redirect", but that is
> not related to this patchset as it already happens on a clean bpf-tree.
> 
> [1] https://patchwork.kernel.org/project/netdevbpf/list/?series=735957&state=%2A

I've now sent V6:

  [2] 
https://patchwork.kernel.org/project/netdevbpf/list/?series=736141&state=%2A

--Jesper

