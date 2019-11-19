Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7ADC1028D1
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 17:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbfKSQAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 11:00:45 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34087 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728106AbfKSQAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 11:00:44 -0500
Received: by mail-pl1-f193.google.com with SMTP id h13so12003428plr.1
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 08:00:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vkm6NyRf8L3VzvQbaeoc5kwbhFthWYUIRF62nRUGNI0=;
        b=BlW79nk4ohmEcMGGg8a0tuzxkBUzH8lrOffCSzOLwxJHJA19GxxJF5nzTW1RjUNw9S
         jrIFMpYqNtveL5oqfdwbt9Hp68ZwGuC+ftv/s/tPQBjzQJiKVC5c+XJK6sYyvtGaLUn+
         Cicyx3cwJlxPkjOTrzaEks1UsvvGqfycbEzZmVJh9oiQ9T9MWtpgTmFMfnLs9dAIyygw
         a++iojRoH4RSbwYjxlLCJnKC6g1vFU+6iqiPufillwJeRWESrHS32ARH9zsHL1vQ/T4T
         Go550dSDOqYhCQNm6DTHqsRxpM39N6bKt6w3KZwzbbdf3W3ugu0aYNDy+nksS4HV0fSL
         IpHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vkm6NyRf8L3VzvQbaeoc5kwbhFthWYUIRF62nRUGNI0=;
        b=mmfYXhuwyx/wOLk+/8PJDVGuG0J2YODSJ4kJ5oYaFUY+IJR1AU//+3bakDD3s2m1KW
         9i829GI8t8009x9USUrLXt77d9ULL+A0ITmY9OBg4TmC6xAXry7hqcAApjjM9yFuxOzK
         NI0cJZlbffohQhJS93zqql+Mn2zZShfUFf92LBtWLoJsf4x4wezDMW3dHrNHgZOSQOTH
         z6kF5/Dll4OlmR5k8Mnjp1v+G5wMt1d0geTUsiRXfI5EozjHmP4tmSsJ7+Dhbae4tYe3
         Yyz/DAHkJv+/8I46sJZ7Nvklr+EuKOj3jJJnqshIddcTo4dSLNe0gp3bjetgna0mqshw
         Pcjg==
X-Gm-Message-State: APjAAAX0+MA/Qr1fqN+cFMXLIH5zawVmr/GFyZcJxUEgRG4pCN3v/P4F
        MfwlPerHwfOgYyNU5d35I8k=
X-Google-Smtp-Source: APXvYqwh8WhMYcb/AjZCmKB5DYCU1rJFSoPehnCqyhNF//W0hs0MVYjj0+4uhl8+1z+6aPsjBb+l5g==
X-Received: by 2002:a17:90a:77c8:: with SMTP id e8mr7203654pjs.83.1574179244156;
        Tue, 19 Nov 2019 08:00:44 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:3071:8113:4ecc:7f4c])
        by smtp.googlemail.com with ESMTPSA id u9sm26101876pfm.102.2019.11.19.08.00.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Nov 2019 08:00:43 -0800 (PST)
Subject: Re: [PATCH net-next v3 2/2] ipv4: use dst hint for ipv4 list receive
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Edward Cree <ecree@solarflare.com>
References: <cover.1574165644.git.pabeni@redhat.com>
 <f242674de1892d14ed602047c3817cc7212a618d.1574165644.git.pabeni@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <34b44ddc-046b-a829-62af-7c32d6a0cbbe@gmail.com>
Date:   Tue, 19 Nov 2019 09:00:42 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <f242674de1892d14ed602047c3817cc7212a618d.1574165644.git.pabeni@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/19/19 7:38 AM, Paolo Abeni wrote:
> @@ -535,11 +550,20 @@ static void ip_sublist_rcv_finish(struct list_head *head)
>  	}
>  }
>  
> +static struct sk_buff *ip_extract_route_hint(struct net *net,
> +					     struct sk_buff *skb, int rt_type)
> +{
> +	if (fib4_has_custom_rules(net) || rt_type != RTN_LOCAL)

Why the local only limitation for v4 but not v6? Really, why limit this
to LOCAL at all? same destination with same tos and no custom rules
means even for forwarding the lookup should be the same and you can
re-use the dst.
