Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 466B82EAC5
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 04:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbfE3Cme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 22:42:34 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33238 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726308AbfE3Cme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 22:42:34 -0400
Received: by mail-pf1-f193.google.com with SMTP id z28so2945716pfk.0
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 19:42:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=KpcFXbFBwLxCGyy/Jk49fis3KZuLGYD4HsSFk6V42fk=;
        b=jD/JMHXcojG8mjE7nXIsxmxwsErMKVuXszEnw9hZZdd6M0qCLQwe00t3p4QTFdjFSW
         6EPwWoh5tWI/Sb1z1ZLkmC/NM6i8ewhEUHf6NGyvG5IqRgbQ6iDtKd3yXuCc+J3/IwQg
         lOA3TNslbdxSov1564Tf45CL6HhJr18NQ6XUgG4HX22m8dVOnmpmicltJtWpIQcUZDEy
         qnPVtZ1UdkNOiL1nzkfooChGeQOJSO6FXvSTCHCQX6YtnBg5TiupZgsS12T7TB17Rv5g
         KLU+1wvyifjFM9d9EIWKzkfp7TPtzuqG8oJmLNdxSaPuOiqRjhwtQEMyEEfqneoYQcpM
         9N9A==
X-Gm-Message-State: APjAAAW0t3PPRgJS9yd2SZQLjcsHIFyTJ+qNLjOq7Q5tLeHKhsdHj8za
        H2GvFf9xzeoiGPViHLdbzpn5Xg==
X-Google-Smtp-Source: APXvYqyMgSr8zbcysyqaP52vbPviSt9ykqRZ6sLQ4REBy1M6NY8HNtd2bruAoXR44eoyah/GzDNUJA==
X-Received: by 2002:a62:ea0a:: with SMTP id t10mr1228321pfh.236.1559184153533;
        Wed, 29 May 2019 19:42:33 -0700 (PDT)
Received: from localhost ([12.206.222.5])
        by smtp.gmail.com with ESMTPSA id b90sm363054pjc.0.2019.05.29.19.42.32
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 29 May 2019 19:42:32 -0700 (PDT)
Date:   Wed, 29 May 2019 19:42:32 -0700 (PDT)
X-Google-Original-Date: Wed, 29 May 2019 19:42:12 PDT (-0700)
Subject:     Re: [PATCH 2/2] net: macb: Add support for SiFive FU540-C000
In-Reply-To: <20190524134847.GF2979@lunn.ch>
CC:     yash.shah@sifive.com, mark.rutland@arm.com,
        devicetree@vger.kernel.org, aou@eecs.berkeley.edu,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        nicolas.ferre@microchip.com,
        Sachin Ghadi <sachin.ghadi@sifive.com>, robh+dt@kernel.org,
        Paul Walmsley <paul.walmsley@sifive.com>, ynezz@true.cz,
        linux-riscv@lists.infradead.org, davem@davemloft.net
From:   Palmer Dabbelt <palmer@sifive.com>
To:     andrew@lunn.ch
Message-ID: <mhng-c7fba225-8035-4808-bdd6-bc05da5d2674@palmer-si-x1e>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 May 2019 06:48:47 PDT (-0700), andrew@lunn.ch wrote:
> On Fri, May 24, 2019 at 10:22:06AM +0530, Yash Shah wrote:
>> On Thu, May 23, 2019 at 8:24 PM Andrew Lunn <andrew@lunn.ch> wrote:
>> >
>> > > +static int fu540_macb_tx_set_rate(struct clk_hw *hw, unsigned long rate,
>> > > +                               unsigned long parent_rate)
>> > > +{
>> > > +     rate = fu540_macb_tx_round_rate(hw, rate, &parent_rate);
>> > > +     iowrite32(rate != 125000000, mgmt->reg);
>> >
>> > That looks odd. Writing the result of a comparison to a register?
>>
>> The idea was to write "1" to the register if the value of rate is
>> anything else than 125000000.
>
> I'm not a language lawyer. Is it guaranteed that an expression like
> this returns 1? Any value !0 is true, so maybe it actually returns 42?

From Stack Overflow: https://stackoverflow.com/questions/18097922/return-value-of-operator-in-c

"C11(ISO/IEC 9899:201x) §6.5.8 Relational operators

Each of the operators < (less than), > (greater than), <= (less than or equal
to), and >= (greater than or equal to) shall yield 1 if the specified relation
is true and 0 if it is false. The result has type int."

>> To make it easier to read, I will change this to below:
>>     - iowrite32(rate != 125000000, mgmt->reg);
>>     + if (rate != 125000000)
>>     +     iowrite32(1, mgmt->reg);
>>     + else
>>     +     iowrite32(0, mgmt->reg);
>>
>> Hope that's fine. Thanks for your comment
>
> Yes, that is good.
>
>      Andrew
