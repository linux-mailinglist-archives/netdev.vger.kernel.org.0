Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2896D146E44
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 17:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbgAWQZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 11:25:51 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41892 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbgAWQZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 11:25:51 -0500
Received: by mail-pf1-f194.google.com with SMTP id w62so1762170pfw.8
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 08:25:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Nzo/EeesMtT8+pXjBytb6EDMDl5fNWcRIsQYNOA5AM4=;
        b=ukIYTF+gazi+wlQK1oKO3hBUJnAA2/GAnOMr6rjauImDVUtVs13TmnqFcszfwIvxum
         2H9UJNP6bxlGVp2lAtCIudbc9GHBttcOC/fHI0O/DL1U58YEJz9Tv7zVqTMSnF8DeMhI
         rGlPPS193fEvweoLv+REyq8b3Akk53RKqnu7yPGi5m1iK5eTQQoE9rxONF8w8wIX5WFU
         izrafqIikmK1GSrThwopKSqB3JLifbuas2h+FShsn6ZLhl8oXxvWNb08JUBje7CF+e9H
         KUeHOm0Ts7tPCDvYmaWE7epq0F4dj2HkawR6uE0bNMRsEzvzoo+UVbKtif/UMrUEspzD
         B4WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Nzo/EeesMtT8+pXjBytb6EDMDl5fNWcRIsQYNOA5AM4=;
        b=Vms0ch1dcCZTDvTkUZtWeCO1RDQubvJ/CLRsgWU0oLbpryzeD/qaf2pJv5Y1eUZL/G
         +T326vXB84fdQvJxXq0CUhXwHTh0+z0IfHVkvddP21ajBgU0P9mGoutUALYTY8ZMhFJ2
         zRijzG9q2UY9Knf6Ka9bQlykC6CN7Xi+XwLBJiMKxpIPO9JCjHdKH4xUVE90dXDtIerF
         DbgKvdGOPSMjIwZuxp2mvz6wy0uoIwk7IvUCNgO9TKHEksk+aGx+tiUbvTMMkZJcdBbe
         fGQfMDe9yiveqz9qy4jfToByLow6ZuZxWNXfqp/WZ5HB3iKGG4Z/f9Qb8S31uUzrepph
         LHnw==
X-Gm-Message-State: APjAAAUu05F/WxO3LXEtTSeF4WN5uB6a7N/KzHa2YCLiSo3z3SGPCLfL
        STa960nji9MRJkUfqXcwUtvcNQ==
X-Google-Smtp-Source: APXvYqxBE5E5aAE8kGSPWh+QCn9YuDKN5TAb8vlzeOyxSF0QBXdHP7pmoIA2H2kLP/5tSC2X7SyxMA==
X-Received: by 2002:a63:e80d:: with SMTP id s13mr4906954pgh.134.1579796750921;
        Thu, 23 Jan 2020 08:25:50 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id bo19sm3329531pjb.25.2020.01.23.08.25.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 08:25:50 -0800 (PST)
Date:   Thu, 23 Jan 2020 08:25:42 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        davem@davemloft.net, bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next 1/4] net: bridge: check port state before
 br_allowed_egress
Message-ID: <20200123082542.06ed0a53@hermes.lan>
In-Reply-To: <20200123132807.613-2-nikolay@cumulusnetworks.com>
References: <20200123132807.613-1-nikolay@cumulusnetworks.com>
        <20200123132807.613-2-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Jan 2020 15:28:04 +0200
Nikolay Aleksandrov <nikolay@cumulusnetworks.com> wrote:

>  	return ((p->flags & BR_HAIRPIN_MODE) || skb->dev != p->dev) &&
> -		br_allowed_egress(vg, skb) && p->state == BR_STATE_FORWARDING &&
> +		p->state == BR_STATE_FORWARDING && br_allowed_egress(vg, skb) &&
>  		nbp_switchdev_allowed_egress(p, skb) &&
>  		!br_skb_isolated(p, skb);
>  }

Maybe break this complex return for readability?
