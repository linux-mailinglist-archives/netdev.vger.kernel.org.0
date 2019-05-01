Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17BBE10634
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 10:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbfEAIsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 04:48:08 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:45999 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfEAIsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 04:48:08 -0400
Received: by mail-io1-f65.google.com with SMTP id e8so14343994ioe.12;
        Wed, 01 May 2019 01:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7c0fhRu6giFCvpGllzdKQiTq639GBLku2ENIbueW4Ss=;
        b=aD3kfAkWBTTNPZjRdGnbaq+dMZVivUxNeHpfyGOCJJs2Goih6UPF9q0d7hkJLsmS7+
         YP7jyb8ZcbHEtWQsJSBspeUoAXnlMN/NDTixRgJiUuHFzf8El655BOR//CKGjuU/aVmx
         NGaOmIXEHisiNiNaeGE9dYsTN/7D9wgepRJTqp3niqgqntKBe3hW1HfTllTOtBGBcSqo
         4UPibKlERJMPt2Bvx9fhvyee4L+AMSCmqdOl60rITtHPJHRELL0CxPQnoYdDAcwCOoWm
         s9tue67ugkhJTH0HEgyni09e8w3VUmyk8gpGHUwQBMon7CYg8fK0fOxWDQa4qLS77QAQ
         X1Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7c0fhRu6giFCvpGllzdKQiTq639GBLku2ENIbueW4Ss=;
        b=NUpBpqGSSwHRAkw0eFCxkkiFrEqXz98tSwAa0MEdYg1z0uer+yhh29h+AcdE5ONa6L
         cVv0+PqiTcK/gqzryFHezGUX0+jZq/2Zv1g1yqI7D/7wBqflEfSTfX0HMy6fwph4B6Cd
         3KBdFXh+YbsWAZPQ5noHXOFXNPFcvisiCSsTRVtCTRoBxu8NBLg1fJ/F2ACRc2LMwH+0
         md5fKd+I2YdTWysJINwndCkvYxmt7BWG6Ss3cUHX5EPuIsoCsO7uCn+uAnxUJoz4SWdA
         dtutS7WFhnUGBgLEcziMon4FL3VbZfmYcJ/hFAiP+qKupOvRMwWduAufwiIuTTktVn00
         CaCA==
X-Gm-Message-State: APjAAAUk5AtdVAboKqf5TIAK7ttcMOZZq/gtt8ers7n+bJsCfucMIhOg
        Cibw5RGmfCswl4c56NAbV3+QO6prxpXklYL4mnRveA==
X-Google-Smtp-Source: APXvYqw/HuAtmgbpfxk0gJq3E5RlW/EZE++1yei6QCykZbPY3eRLkpe6k6CNxVVwu2HyBNQoH/+0g3cBBW6AIkORAQk=
X-Received: by 2002:a5d:91c1:: with SMTP id k1mr956091ior.180.1556700487522;
 Wed, 01 May 2019 01:48:07 -0700 (PDT)
MIME-Version: 1.0
References: <20181008230125.2330-1-pablo@netfilter.org> <20181008230125.2330-8-pablo@netfilter.org>
 <33d60747-7550-1fba-a068-9b78aaedbc26@6wind.com>
In-Reply-To: <33d60747-7550-1fba-a068-9b78aaedbc26@6wind.com>
From:   Kristian Evensen <kristian.evensen@gmail.com>
Date:   Wed, 1 May 2019 10:47:56 +0200
Message-ID: <CAKfDRXjY9J1yHz1px6-gbmrEYJi9P9+16Mez+qzqhYLr9MtCQg@mail.gmail.com>
Subject: Re: [PATCH 07/31] netfilter: ctnetlink: Support L3 protocol-filter on flush
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Thu, Apr 25, 2019 at 12:07 PM Nicolas Dichtel
<nicolas.dichtel@6wind.com> wrote:
> Since this patch, there is a regression with 'conntrack -F', it does not flush
> anymore ipv6 conntrack entries.
> In fact, the conntrack tool set by default the family to AF_INET and forbid to
> set the family to something else (the '-f' option is not allowed for the command
> 'flush').

I am very sorry for my late reply and for the trouble my change has
caused. However, I am not sure if I agree that it triggers a
regression. Had conntrack for example not set any family and my change
caused only IPv4 entries to be flushed, then I agree it would have
been a regression. If you ask me, what my change has exposed is
incorrect API usage in conntrack. One could argue that since conntrack
explicitly sets the family to AF_INET, the fact that IPv6 entries also
has been flushed has been incorrect. However, if the general consensus
is that this is a regression, I am more than willing to help in
finding a solution (if I have anything to contribute :)).

BR,
Kristian
