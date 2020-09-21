Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAC652729BD
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 17:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbgIUPQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 11:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbgIUPQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 11:16:01 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F553C061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 08:16:00 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id p9so18273837ejf.6
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 08:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+0oIyuiL43c1vAuq2+oH/3oY5m+86YM1dQdDzSjxeuI=;
        b=c2p9jAMp6IfEMzWbxY8gNaB1MrjOJV/mBYR93G5sSAzdyaMuo5rhZjD0XaIRzUPVl4
         gULm3YNBXBAJa9gAWd46c/M9YeDPbHwihnIb0yyZiAEZ7cE3dC8Jnbf9kykDU1ZHX7Yl
         MDYtYzX+borGL6X/0n1z66LJl+Wk8mLLkffM6FKKMOUEikNvw3EIhKpgkjpQFMl0rRZx
         c/t85V6oyo++eD2ajPCSu5g/5g3pBo1/QaUUfQcm2KLZyY6DmyMoQFV7PUOXUxjxgLhR
         IKL91mKVjU3pVrjNZTnvVLgpoDuN/b9kic/67wyAPjuCyeT9fxY9SZ8OErz9jsYSyfQ7
         Sq2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+0oIyuiL43c1vAuq2+oH/3oY5m+86YM1dQdDzSjxeuI=;
        b=Jg9uETiMvsmY5GrHY9GVO3cIBY/6pP/cmdxmDlxdFODzfPrL1ZaoxpMSxeC+Ilskhj
         pdwzajVENWNO/6+ktxEOsS+WzZ8kLzKAawxdmiqiuMRYfB32bCx92NmS9z9mXvDLZr8+
         IabjgbPGgHPCj0Kdp6e/4tDBH2QRewGwpQnD8t26YsLodTJlPhANNETPsDak1QF5331C
         oKOsCyOoQahLI6c+niv83tqvKVzz6KCUti+VFs+A5xDn+6wSvHoRpsYEi0mYVYZZDmmY
         jWb81pzYfGP+s612eGYrlWoClMeeFbqdZyUJKPtyXn3JP/U64EWFgcQ5H8qK/QYhsPRx
         Lbvg==
X-Gm-Message-State: AOAM533Vj5L8Fa7WNrU6fPRbRHDV3yftdWMtY8oyu7s+4fGUR2T7pCqe
        Ppf3b26PddJUj9mLWW+wsrYOF/ZPcUOv3e6v
X-Google-Smtp-Source: ABdhPJxRMc2NtOf3lUU3N42ZPfOlZW/3MxxjO80/oc2mh3ymuk+IJ5PahUpyHTdL7UZLZjvpMUbpBQ==
X-Received: by 2002:a17:906:b74c:: with SMTP id fx12mr46636268ejb.547.1600701358622;
        Mon, 21 Sep 2020 08:15:58 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([2a02:578:85b0:e00:6d5c:f5b2:93d8:8eef])
        by smtp.gmail.com with ESMTPSA id y21sm9089603eju.46.2020.09.21.08.15.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2020 08:15:58 -0700 (PDT)
Subject: Re: [PATCH net-next v3] mptcp: Wake up MPTCP worker when DATA_FIN
 found on a TCP FIN packet
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
References: <20200921145759.1302197-1-matthieu.baerts@tessares.net>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <ef95c4e2-37ee-bb77-0472-9fd7e805eecb@tessares.net>
Date:   Mon, 21 Sep 2020 17:15:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200921145759.1302197-1-matthieu.baerts@tessares.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, Jakub,

On 21/09/2020 16:57, Matthieu Baerts wrote:
> From: Mat Martineau <mathew.j.martineau@linux.intel.com>
> 
> When receiving a DATA_FIN MPTCP option on a TCP FIN packet, the DATA_FIN
> information would be stored but the MPTCP worker did not get
> scheduled. In turn, the MPTCP socket state would remain in
> TCP_ESTABLISHED and no blocked operations would be awakened.
> 
> TCP FIN packets are seen by the MPTCP socket when moving skbs out of the
> subflow receive queues, so schedule the MPTCP worker when a skb with
> DATA_FIN but no data payload is moved from a subflow queue. Other cases
> (DATA_FIN on a bare TCP ACK or on a packet with data payload) are
> already handled.
> 
> Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/84
> Fixes: 43b54c6ee382 ("mptcp: Use full MPTCP-level disconnect state machine")

A small mistake from my side, this patch is for -net and not net-next :/

Sorry, with these 3 patches with the same code, it really looks like we 
don't want to have this patch sent properly :)
I can resend a v4 with the proper subject if you prefer.

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
