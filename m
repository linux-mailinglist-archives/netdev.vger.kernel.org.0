Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8ABE5E70B
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 16:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbfGCOpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 10:45:52 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:40865 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbfGCOpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 10:45:51 -0400
Received: by mail-ed1-f66.google.com with SMTP id k8so2352741eds.7
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 07:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+tmiNv+TLMGHyyEkT5xfkoFVien9ty47VxBrX6zmG84=;
        b=hWak+RqI2odlS+UqlG5kKA/fiPaFeLhQvPbMNlPMIiTGndiZCfzufNiegt3+R2Eqdd
         uDDeDgcm2Dk8v6O9c6NW2T0wQhEqkZRPru/xEqoNCp21lYTRD8+JpvQ1o4C10qsvmVFI
         /tA5wjfbqRreDXPEZefYe9/wXabBP28TvklvHjQhT1upcf6weXPF0YrQxAmMZ0aNNfa/
         yv5amKal8tco3zZmi/jAHIWBBDK9ChLCfnFze8NC4xBtDoK8ivX/pvRa8SqYASDFyujA
         xbnIbo5qjzT+prsTCSKYhkFZ+MHzlujYQh779U0Q/vog618tDeCNQHyxNm/6//wLdEhJ
         Vq7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+tmiNv+TLMGHyyEkT5xfkoFVien9ty47VxBrX6zmG84=;
        b=kfUSBnkMgQHx7xfJQkfhjgmuEt8DTxNrtb5iC0ACTg7LszCHGkhDTlFWYSpmw1njGU
         HqNS12IxOnc3BDGzGM/Xid4NpYxT4KgvKWWTvW3MquD9yRlwnTOF1ofJbWnTTG96WBXZ
         ajP5QQT8wW8VDExmNR8X+nhzo8PArt8nj9pVRm9xWnBNxVsUmpAqteC8230mJb6AgCvG
         kbmb4HisjB0sNPI9mN5HHukVkCMmeTzEseO+WRY5uus//ZphG7UBfac/1dsxmcW7fI0a
         g+n4i3egF0XAnAfFQ7KtEtxg2ao+R9z0eSjbN0OXSpKYzEOQMfnjXYh0rIuEdlZMbpWz
         o3gg==
X-Gm-Message-State: APjAAAV1PFZq31NN12/QJWsIJ6VxguRR9pvFXpe47XgsgpiHVhcmquQf
        EzWn74B5g1v7GVsSLTIoD0Q5jgEQ7F5UXZhKliCIgQ==
X-Google-Smtp-Source: APXvYqwnuEe73AR8A4b7wKwPLKau99+ibKY2wRsp3hKzirZ6s75q5AjVBK9QRKr0mbOFBQpTzRk9h3dvkSkh/uDjd38=
X-Received: by 2002:a17:906:914:: with SMTP id i20mr34721622ejd.213.1562165150015;
 Wed, 03 Jul 2019 07:45:50 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1562162469.git.pabeni@redhat.com>
In-Reply-To: <cover.1562162469.git.pabeni@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 3 Jul 2019 10:45:13 -0400
Message-ID: <CAF=yD-+z8-rq5bcrm3NdMv4kHp1HvoucxVBG3kLHxV9NS35EBw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/5] net: use ICW for sk_proto->{send,recv}msg
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 3, 2019 at 10:07 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> This series extends ICW usage to one of the few remaining spots in fast-path
> still hitting per packet retpoline overhead, namely the sk_proto->{send,recv}msg
> calls.
>
> The first 3 patches in this series refactor the existing code so that applying
> the ICW macros is straight-forward: we demux inet_{recv,send}msg in ipv4 and
> ipv6 variants so that each of them can easily select the appropriate TCP or UDP
> direct call. While at it, a new helper is created to avoid excessive code
> duplication, and the current ICWs for inet_{recv,send}msg are adjusted
> accordingly.
>
> The last 2 patches really introduce the new ICW use-case, respectively for the
> ipv6 and the ipv4 code path.
>
> This gives up to 5% performance improvement under UDP flood, and smaller but
> measurable gains for TCP RR workloads.
>
> v1 -> v2:
>  - drop inet6_{recv,send}msg declaration from header file,
>    prefer ICW macro instead
>  - avoid unneeded reclaration for udp_sendmsg, as suggested by Willem
>
> Paolo Abeni (5):
>   inet: factor out inet_send_prepare()
>   ipv6: provide and use ipv6 specific version for {recv,send}msg
>   net: adjust socket level ICW to cope with ipv6 variant of
>     {recv,send}msg
>   ipv6: use indirect call wrappers for {tcp,udpv6}_{recv,send}msg()
>   ipv4: use indirect call wrappers for {tcp,udp}_{recv,send}msg()

Acked-by: Willem de Bruijn <willemb@google.com>
