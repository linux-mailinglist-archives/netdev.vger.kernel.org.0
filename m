Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 555D41832B0
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 15:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbgCLOTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 10:19:00 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42520 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727123AbgCLOTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 10:19:00 -0400
Received: by mail-wr1-f68.google.com with SMTP id v11so7697702wrm.9
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 07:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aWarP+EBKLN3gxEo6HVS4CLZ1VqjakO82JFsSBfucsw=;
        b=WhuD3Dl0PsfqPRphDIrF4efaakThsk8kod+ouXlriMsTvu7NCqg48RQ8NbGRGwmvdc
         mGyPd/PlqI8iyaFaTCb+nOJNf8eWwGc8dGHP4do4kxf49VY6lOU6DBFeewBIxaWkW0t8
         bzejvsSuEUFn0kLjZnyVmJ4VTx5lu3K1iVe8bV7zKZz69Yd3OsFHiNFPy1SS3bUPF2XZ
         TrcgW3TseED09lxJop2GZT+HxczkkJiM9QQpFVikqVkQxYEphmpn859+k9WeFHk4Eum/
         4eL0jSLoH/gGcbOIsVf9t/GGfG60dwpA/LoaMuLa+kO3USd7jTGjUDmc13cBgqetMMKB
         z8eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=aWarP+EBKLN3gxEo6HVS4CLZ1VqjakO82JFsSBfucsw=;
        b=Dvua2XwecyNDrFyl9bJ6gXCtfvpXnzGT5QtRVnxFe3spVdfdZ9xke1Jx93ToFCArna
         IvsdIR/rNCaREfzK/W0CV0Xu+aRm5Y9bp+S2RUd09ohlCmBHMuVbOCdfwcaw46H+Du2J
         mhSP2rU8sTLtnYylQuEWlekngDP+pObJYlNIr70RLb6ynFv6Gfu9FcfKYHNsHlySyc9+
         8zwg08mU8X4EWc5XbQ3S31MjEPf3z4uL3A8aII9kBGiilaD7SOVIfgYq+ZUnddgiNb93
         +N7vuxLvdlk9nQYJxEXqBVr/0zwC1DXE8FieJ0F3LjZAJGiLc7TkLyofv3xLnNwNozST
         e66Q==
X-Gm-Message-State: ANhLgQ3IL5QwMait1PQm/nHumDybj3Smf0HgxasXan4JWOScXgya/yzv
        3a/Xc6KEMvgp+rdCLAVJ6FjvhAbCr8I=
X-Google-Smtp-Source: ADFU+vsw56RVGklYCvDBb6zkLZVZ1nz8WlqMvoI5GiIPVmCjnNErT9D8BoK1xGHTruDJBE158HvEOg==
X-Received: by 2002:adf:a2d9:: with SMTP id t25mr11037399wra.84.1584022738730;
        Thu, 12 Mar 2020 07:18:58 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:7198:d5d7:af4f:fa54? ([2a01:e0a:410:bb00:7198:d5d7:af4f:fa54])
        by smtp.gmail.com with ESMTPSA id i6sm43656209wra.42.2020.03.12.07.18.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2020 07:18:58 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH] vti6: Fix memory leak of skb if input policy check fails
To:     Torsten Hilbrich <torsten.hilbrich@secunet.com>,
        netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>
References: <5fe49744-88ca-a7ac-d71c-223492811545@secunet.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <22c8ef07-70f4-e6a5-3066-357e1e688e72@6wind.com>
Date:   Thu, 12 Mar 2020 15:18:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <5fe49744-88ca-a7ac-d71c-223492811545@secunet.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 11/03/2020 à 11:19, Torsten Hilbrich a écrit :
> The vti6_rcv function performs some tests on the retrieved tunnel
> including checking the IP protocol, the XFRM input policy, the
> source and destination address.
> 
> In all but one places the skb is released in the error case. When
> the input policy check fails the network packet is leaked.
> 
> Using the same goto-label discard in this case to fix this problem.
> 
> Signed-off-by: Torsten Hilbrich <torsten.hilbrich@secunet.com>
Fixes: ed1efb2aefbb ("ipv6: Add support for IPsec virtual tunnel interfaces")
Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
