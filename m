Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65D0BE173A
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 12:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404224AbfJWKBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 06:01:42 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:36813 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403810AbfJWKBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 06:01:41 -0400
Received: by mail-ed1-f67.google.com with SMTP id h2so15292742edn.3
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 03:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5emlzdBcyQKRWblamuH9LkuU6rz1TF+chv1k3FvAKlk=;
        b=qZG6MBc/wMQBruGKlUudZ16Cy3/0u1rYy9yPr4J8lmbHSVjI7U3DwofG4OG50HL0l6
         joV4svx4AWbdEiKn+VTlvf5xCMAF4mnBgR4xRY6yegpME8eLp1JxPJx2mXQnXuhm+bBu
         I9vnea61du2YbZZfi4HYX6xiLdy1Rnfemt8WOTu2o7z//ypGoruF50FdbllXhUUi5yyr
         o6Ly1WBFcoXw4jJAIBbsegJkuLjUl1qVQ87bJ2+djojwE1Va6ACuK1bhzAk7RxY2wBCT
         i7SI82iaSPdh0AwMlwhhe15b+SShSxOX3/AsrGFqWdVyoRb/3N5c1Ar/kfz1ppMDYvUi
         FulQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5emlzdBcyQKRWblamuH9LkuU6rz1TF+chv1k3FvAKlk=;
        b=EQQ6e0M5Ar2AGyNLqq6Cv1O6ITskGs8mpL3P2MSTAqS+SdPWw8/klya/c7sSoNpHq6
         Ay4ytIxOPiGoFXcT4Io4znw9xJi/Fjz/enuESvKYFI2oV1iyBc2uXJvfilxsCMrQu3+P
         sXjLNgecsWq1Y0pwWLJHUiEaUve9XmTTYSUtQhPf191Zq8LX9cq4cqbKKGJLPH1Rih79
         yyifPqmt/X+2Ycd8kIgTxQctZ+bt0k+Em8U6Zd/tgZo9kUOLOCv4PHlgil+h2NUZgmAV
         6gfgpJaMMVKxGtCa+saSuucVFNVmq6b1sf44ii2/c2aSjSkw6SHGSQVlj+/MJCbpkzuS
         FKvw==
X-Gm-Message-State: APjAAAXO3G92QKAxA1uJFWPow9lNVH6QQB0sua9R4+tjOFoCKK+2fyMp
        ThGI1ocissrF4N+Rm8oUYfo2Kg==
X-Google-Smtp-Source: APXvYqw8dDyDfX6iQ1Eb5GA37WmLKMyPTrnlnq5CcNkjMARm/3a+NWS7xK7hnKz7gJ4YxFd2hmYpBw==
X-Received: by 2002:a17:906:4d4f:: with SMTP id b15mr8904707ejv.81.1571824897561;
        Wed, 23 Oct 2019 03:01:37 -0700 (PDT)
Received: from netronome.com ([62.119.166.9])
        by smtp.gmail.com with ESMTPSA id a22sm426052edv.7.2019.10.23.03.01.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 03:01:37 -0700 (PDT)
Date:   Wed, 23 Oct 2019 12:01:32 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller " <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Paul Blakey <paulb@mellanox.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 4/4] bonding: balance ICMP echoes in layer3+4
 mode
Message-ID: <20191023100132.GD8732@netronome.com>
References: <20191021200948.23775-1-mcroce@redhat.com>
 <20191021200948.23775-5-mcroce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191021200948.23775-5-mcroce@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 21, 2019 at 10:09:48PM +0200, Matteo Croce wrote:
> The bonding uses the L4 ports to balance flows between slaves.
> As the ICMP protocol has no ports, those packets are sent all to the
> same device:
> 
>     # tcpdump -qltnni veth0 ip |sed 's/^/0: /' &
>     # tcpdump -qltnni veth1 ip |sed 's/^/1: /' &
>     # ping -qc1 192.168.0.2
>     1: IP 192.168.0.1 > 192.168.0.2: ICMP echo request, id 315, seq 1, length 64
>     1: IP 192.168.0.2 > 192.168.0.1: ICMP echo reply, id 315, seq 1, length 64
>     # ping -qc1 192.168.0.2
>     1: IP 192.168.0.1 > 192.168.0.2: ICMP echo request, id 316, seq 1, length 64
>     1: IP 192.168.0.2 > 192.168.0.1: ICMP echo reply, id 316, seq 1, length 64
>     # ping -qc1 192.168.0.2
>     1: IP 192.168.0.1 > 192.168.0.2: ICMP echo request, id 317, seq 1, length 64
>     1: IP 192.168.0.2 > 192.168.0.1: ICMP echo reply, id 317, seq 1, length 64
> 
> But some ICMP packets have an Identifier field which is
> used to match packets within sessions, let's use this value in the hash
> function to balance these packets between bond slaves:
> 
>     # ping -qc1 192.168.0.2
>     0: IP 192.168.0.1 > 192.168.0.2: ICMP echo request, id 303, seq 1, length 64
>     0: IP 192.168.0.2 > 192.168.0.1: ICMP echo reply, id 303, seq 1, length 64
>     # ping -qc1 192.168.0.2
>     1: IP 192.168.0.1 > 192.168.0.2: ICMP echo request, id 304, seq 1, length 64
>     1: IP 192.168.0.2 > 192.168.0.1: ICMP echo reply, id 304, seq 1, length 64
> 
> Signed-off-by: Matteo Croce <mcroce@redhat.com>

I see where this patch is going but it is unclear to me what problem it is
solving. I would expect ICMP traffic to be low volume and thus able to be
handled by a single lower-device of a bond.

...
