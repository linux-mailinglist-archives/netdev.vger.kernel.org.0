Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4979222647F
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 17:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730537AbgGTPpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 11:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729746AbgGTPpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 11:45:33 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ABB2C061794;
        Mon, 20 Jul 2020 08:45:33 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id d14so4040283qke.13;
        Mon, 20 Jul 2020 08:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7wm0oMA29Q1w+zSeZjjlRnkZAL7H3qOLrO6VrVSXeHw=;
        b=Q4cyqP7ciSayfcBJcyYV9UOx+KwWVGGMtvXyo+/pPX+MMLSUAPeLlTB7iA7fCTV/Gh
         8EgSvSSwnGxET1RZafj/RcXQHnCDu7WfDCC9/xIjCsTXTJNc28PIPENb9qHqZyc2PHtP
         EaaNFrqqv9FaujNa2Jyx+/rKm/hywm6M+mjyKckR9UuAHpJcIT0fs6IqyYY1embBQaE6
         CNUISapqPDPPpPSJKNbZ7GKNaPZMWSiKlXkoDXXNaImWjiGN/505oDlu9SgAuKJKmcd/
         2otYVDEDb9AQHrc1N0zyxdj1rpOJlSqlAdnEnQcYfxJQaALSUQOrbVWpKEV/u6NWGc8Y
         jqnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7wm0oMA29Q1w+zSeZjjlRnkZAL7H3qOLrO6VrVSXeHw=;
        b=oTkJW1EvRg+UCE2oiTsBKzZuGVzyKDxZciBJ0aYtPdeUkcSHPsxN89oJUO9pHEfwRY
         VkqvrEK0eiJRt8PYGBVe7lC/aRspeoE/7apyENsZ39H7EAmqp6JwvzRIEmICV2qctV/o
         ooWl4tuQZF420EpwlZCgUyVuzDS0rOx5cXs5kDybWnHMJIBUc6m6p5v3Q+r3dcZnrwZa
         pze5Q2PKthk+Lwp7Alxclzty/0AaYz/1/4Wi0vCYk4dn7CmnH9wZ+JZtZDh52PUk1plF
         fBpK97R3BZAwojIUWDCcEKaGrQ4m8s7x2kBBGh+z0pCB1v1mc6O5h5I+4LT6a0wVjBii
         BpnQ==
X-Gm-Message-State: AOAM530orf0y9Cdk1GcpQ3/L96sc0xPVix5kK1JHGSMG9eDpZCPRcz/p
        sq7ebKR6biKDDvUZqKuC0Ms=
X-Google-Smtp-Source: ABdhPJxE+cZBrKwC0TzIZBKJkkIEVhZ7GLKC7+l1E21bCB2PeLyFzrZXWTc7tiD9J1DOQ1A6Crd4mQ==
X-Received: by 2002:a37:27c2:: with SMTP id n185mr21110967qkn.459.1595259932718;
        Mon, 20 Jul 2020 08:45:32 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:247a:2d5a:19c4:a32f? ([2601:282:803:7700:247a:2d5a:19c4:a32f])
        by smtp.googlemail.com with ESMTPSA id j72sm8765112qke.20.2020.07.20.08.45.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jul 2020 08:45:32 -0700 (PDT)
Subject: Re: [PATCH bpf-next] bpf: cpumap: fix possible rcpu kthread hung
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, brouer@redhat.com, daniel@iogearbox.net,
        lorenzo.bianconi@redhat.com, kuba@kernel.org
References: <e54f2aabf959f298939e5507b09c48f8c2e380be.1595170625.git.lorenzo@kernel.org>
 <874kq2y2cy.fsf@cloudflare.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a77cf1a2-6dc8-0a3c-3bb8-d2d9681ccb8f@gmail.com>
Date:   Mon, 20 Jul 2020 09:45:29 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <874kq2y2cy.fsf@cloudflare.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/20/20 3:14 AM, Jakub Sitnicki wrote:
> I realize it's a code move, but fd == 0 is a valid descriptor number.

this follows the decision made for devmap entries in that fd == 0 is NOT
a valid program fd.
