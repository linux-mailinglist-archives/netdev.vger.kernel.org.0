Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7C0A4DE2D
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 02:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbfFUAuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 20:50:17 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:33786 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfFUAuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 20:50:17 -0400
Received: by mail-io1-f68.google.com with SMTP id u13so19560iop.0
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 17:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=E4bXYn7+uZP5mjQyrjONJZ4sQOv4qGazCBC6u7N2LVk=;
        b=tIB/X/zaA7HgpoxUaNLRfKXKhFH/Oh9BhTCK9hx15WcQDdQ/MPa6BkZ/fn9Jv4yKns
         DuEKHdKeSGlJc9Y2cnN9t6J+LVjlMYgaHBBaHZAOI4naGL/s5eLZcCK6nJwfl7oaocGp
         L9MGYPBwdyfLS35IeoGjZSE9z79EcfvKItevkjxgGHq5a0wuiGKyk6dUdk8smRa8SU32
         cswOvUeFAXo7YSwdcy000GhVvq99XNckrx7allpOgbhy7gQf1OJ+y2TILR5HXjp/gK8V
         kHS66FSlEgN9m+HMDQ4+jwLe/jyNZvb9OXGJZdv2upn1O3lQ0Wa3ipHozqV63FIMeBBb
         nytw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E4bXYn7+uZP5mjQyrjONJZ4sQOv4qGazCBC6u7N2LVk=;
        b=lESOIPQle5ayldlk2hNB0SY1eAmR6v/E5mrZ09KsMYWsAJScdC+9ahjhQcgYtm6jik
         HVKLvSnLiUDmiSgZwMd2SaePw+/+jRDnYOKUv73uGlK+t3VP4vB0wjnPNFNuT6XY9fQS
         cB+/oVx2mez3FpUACbGUjvbas3IGuElplQg12bzEcUBlxDvEH7d2dP2HEECDZGe8dJDh
         6ZSlxAUbAMT+lqoqbtJyBO6ct68Zf/WNQ9tV4jD598BuOrJybe34J6f9CNMdLDKzxxIs
         +gGKm5dBiJgvLU1Oq+3bq/C2hLVfC9P5hlRHI3cFhlo72jFv9dfd5P85sytzvdEQFVP+
         OZ/A==
X-Gm-Message-State: APjAAAWQfvo3hxRw1RrX/Bsy0RfB43FEMRCO/PDhwMz4d/JtIEwFP21F
        QmP3EKKIPgRPpGss9MKduhA=
X-Google-Smtp-Source: APXvYqx99qMI3R/ThfFNacXvF3BmXaHXcslQTVM5kNB5Y1iFll7X7KjKDD/9TAXk+ju7CCrMgbiP7g==
X-Received: by 2002:a02:5502:: with SMTP id e2mr21773856jab.87.1561078216896;
        Thu, 20 Jun 2019 17:50:16 -0700 (PDT)
Received: from ?IPv6:2601:284:8200:5cfb:4cec:f7ec:4bbc:cb19? ([2601:284:8200:5cfb:4cec:f7ec:4bbc:cb19])
        by smtp.googlemail.com with ESMTPSA id t22sm1072867ioc.75.2019.06.20.17.50.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 17:50:15 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 0/5] ipv6: avoid taking refcnt on dst during
 route lookup
To:     Wei Wang <tracywwnj@gmail.com>, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Wei Wang <weiwan@google.com>
References: <20190621003641.168591-1-tracywwnj@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b7e58c88-a1d8-323d-caa2-99360ca5144e@gmail.com>
Date:   Thu, 20 Jun 2019 18:50:11 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190621003641.168591-1-tracywwnj@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/20/19 6:36 PM, Wei Wang wrote:
> From: Wei Wang <weiwan@google.com>
> 
> Ipv6 route lookup code always grabs refcnt on the dst for the caller.
> But for certain cases, grabbing refcnt is not always necessary if the
> call path is rcu protected and the caller does not cache the dst.
> Another issue in the route lookup logic is:
> When there are multiple custom rules, we have to do the lookup into
> each table associated to each rule individually. And when we can't
> find the route in one table, we grab and release refcnt on
> net->ipv6.ip6_null_entry before going to the next table.
> This operation is completely redundant, and causes false issue because
> net->ipv6.ip6_null_entry is a shared object.
> 
> This patch set introduces a new flag RT6_LOOKUP_F_DST_NOREF for route
> lookup callers to set, to avoid any manipulation on the dst refcnt. And
> it converts the major input and output path to use it.
> 
> The performance gain is noticable.
> I ran synflood tests between 2 hosts under the same switch. Both hosts
> have 20G mlx NIC, and 8 tx/rx queues.
> Sender sends pure SYN flood with random src IPs and ports using trafgen.
> Receiver has a simple TCP listener on the target port.
> Both hosts have multiple custom rules:
> - For incoming packets, only local table is traversed.
> - For outgoing packets, 3 tables are traversed to find the route.
> The packet processing rate on the receiver is as follows:
> - Before the fix: 3.78Mpps
> - After the fix:  5.50Mpps
> 

LGTM. Thanks for doing this - big improvement.

Reviewed-by: David Ahern <dsahern@gmail.com>


