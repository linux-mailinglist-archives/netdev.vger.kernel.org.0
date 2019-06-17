Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8798E483EE
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 15:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfFQN3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 09:29:19 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:46765 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbfFQN3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 09:29:19 -0400
Received: by mail-io1-f65.google.com with SMTP id i10so20991506iol.13
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 06:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=puWqUZ2IJK+4X7IGbVhqVy/p0SHF6HWirxK6e2Lnr1E=;
        b=PHt0o12GduPGVKH+REmvdO2mLN3ha5HA4LY4vJ7Grr06m8F/VCsMwY/Coz8+MAXcFh
         0VXy5zIJAcEmFxlKyIMdRV2OOTeiaj3wClNYV0PtlGPwKb1B2dVOSXm695YvvnMCd5Gd
         wX+Z4rFtPg5YZzhpcmpy3leSzCt3sfB+NpmE1GYO4+TU5+QPfnkpKbbdyJJWOD2cZwID
         qSwZF+9wID4alvvRQsBmnHmHzZ9ixhqbL760J4yPOiMxXXSipDzpQwSZa3ylWs+NZ58a
         l54tIUOasr7YojwgVpH43TOqBrKcIKLbVVCBDiZrz/cSHzQg2TSY5SGdxBS9VSv0iPyF
         dlEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=puWqUZ2IJK+4X7IGbVhqVy/p0SHF6HWirxK6e2Lnr1E=;
        b=bkfsX0Y//xDP/Hg/uMIvyqTYDMZhGegUqGQhhxfgt+DFpOhoSAZrvP5fxuG3yPb5oW
         POZVc6dWul4tQMzm43sAr1ZvMFmstbS3nMc1RDU4ldsB3agGdODqqrzeOnkB0OmNc+2w
         I1f/OQQXXX/lDQhbbfGWtTWD5TFPqiffBcnMQj0utUjJMgulPdVjKVbowSKhz7XWl9X4
         7I6paMPfG8OeD82L3bL5EWGv5YFVXJu9+vcmEGFBMlYoiK5X8697TXvFVd0brLIkoiOw
         TJpkYci3PTSSodry6evHRi4ctbiKx0nNVtO3Qceg+ROVy4OzXFlxzbrVziq1EfplEw2x
         f+rA==
X-Gm-Message-State: APjAAAVpMuf9B+IXgeoQoCBI6C65czsDAaMPBCWNTSGiiUNFl7iyjgxU
        hcFfQ+QHrk4YgeVsL66eKRcRG7Qp
X-Google-Smtp-Source: APXvYqzl7pqIeyFMANX0cphKHm/zOh7JyWf1U+6YUqTNH5FC/V03lS1GVtAz5yFiHJJ0AbjuAW6wQw==
X-Received: by 2002:a02:1146:: with SMTP id 67mr85520296jaf.10.1560778157942;
        Mon, 17 Jun 2019 06:29:17 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:f1:4f12:3a05:d55e? ([2601:282:800:fd80:f1:4f12:3a05:d55e])
        by smtp.googlemail.com with ESMTPSA id a7sm9645416iok.19.2019.06.17.06.29.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 06:29:17 -0700 (PDT)
Subject: Re: [PATCH net v4 2/8] ipv4: Honour NLM_F_MATCH, make semantics of
 NETLINK_GET_STRICT_CHK consistent
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
References: <cover.1560561432.git.sbrivio@redhat.com>
 <58865c4c143d0da40cd417b5b87b49d292d8129d.1560561432.git.sbrivio@redhat.com>
 <9abeefb6-81a7-dc0a-30f4-f15ccf4edc86@gmail.com>
 <20190615052332.16628b2c@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <da3e93e8-9dc6-fc45-4b24-d527c9a206fc@gmail.com>
Date:   Mon, 17 Jun 2019 07:29:15 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190615052332.16628b2c@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/14/19 9:23 PM, Stefano Brivio wrote:
> 
> 1. we need a way to filter on cached routes
> 
> 2. RTM_F_CLONED, by itself, doesn't specify a filter
> 
> 3. how do we turn that into a filter? NLM_F_MATCH, says RFC 3549
> 
> 4. but if strict checking is requested, you also turn some attributes
>    and flags into filters -- so let's make that apply to RTM_F_CLONED
>    too, I don't see any reason why that should be special
> 

I guess I am arguing (and Martin seems to agree with end goal) that
RTM_F_CLONED is special. There are really 2 "databases" to be dumped
here: FIB entries and exceptions. Which one to dump is controlled by
RTM_F_CLONED.
