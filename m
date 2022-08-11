Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6897858FE68
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 16:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234435AbiHKOen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 10:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234432AbiHKOem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 10:34:42 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 352E46C127;
        Thu, 11 Aug 2022 07:34:41 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id z8so8745842ile.0;
        Thu, 11 Aug 2022 07:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=g4Lt8sIaBS+5GNyKCI0xXQq/3t+KK2eifkIq7q1O+Tg=;
        b=jF42HMLMlx+gwM0oHpdErRsCvymj+L8MqwLrctbJs5c4qJDE6Y0IGlNyzihEtTlHyx
         G4sxQu3KDQYFKRxlXYQamfgKZK6scaZSxp5kntEDacNUMhsRAw5vdnJUFeBY8oTgupdG
         MDMToPX+xXgY3CSmBy6s6jUwMtkQHlcT6c/UlW1R9RNW9NEbZ/helx9tToHrOh1DgKcV
         eEHYl4yZn4nyLfJ2K7WI8ZRWXHMDtrejcPLaHQshLIRHTx3dMXN2bDJx68A7L99G3hMJ
         i2JkjXtfMClSsnZDQP5yaMpG4v6geurC59f0zmVOSqkUdfpP5H0BIs4UnGXkd+s3zJ6F
         ylyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=g4Lt8sIaBS+5GNyKCI0xXQq/3t+KK2eifkIq7q1O+Tg=;
        b=tKkeqzPO8t6kwCQQjFwSIYsLCeTFk3hOljL0GEx1H0KymmYDrXIoQNP72W+OlaZU1W
         vw5SeJ1WiL6yR6Hkxm8E/GiTj4IFGRv1ovvgGi/uE7/njiaQqdNyJqxAttefNZaatckR
         4Czyzx1dDwdnQjGGjweJHMRtCh4rdl//y1uCkRTKNu8bUeI3/aGCvwYaP/EXNE9i93KD
         gxmRMkV9SBWGMxP4AuyKAmzsc/UwNWutle8fjnzownvE0arXJ6Upe9GOlj51zgka6try
         y2mqI/EFJoWJWd0NhdMwhhvJMMQAenI4HNb4H3giYSg9pO10EiWC4Mkusakpap2pYJwi
         znrw==
X-Gm-Message-State: ACgBeo3vXQ/713AB/CwO5BQblMtuejJ/w4c2zSlelc4YaQTdXUUB0KRT
        Z46IMFTGFMbyfNzMz2cSOfcYhJeG/dvG04dx7no=
X-Google-Smtp-Source: AA6agR7pn/C9nLVLQImfQsJubaIZigoS9bMJ7QUyRTX9OR9Ihz4ZFYKdJarEZ0/mH6Q5gUGfo6SeydK6ieogykoDc7U=
X-Received: by 2002:a05:6e02:17c6:b0:2dd:d9dc:6387 with SMTP id
 z6-20020a056e0217c600b002ddd9dc6387mr15082915ilu.321.1660228480629; Thu, 11
 Aug 2022 07:34:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220811120708.34912-1-imagedong@tencent.com>
In-Reply-To: <20220811120708.34912-1-imagedong@tencent.com>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Thu, 11 Aug 2022 16:34:29 +0200
Message-ID: <CANiq72=Eq1265hYhEVTGuh-_ZW+3HjWkwaktEfs7H7yPERfO0w@mail.gmail.com>
Subject: Re: [PATCH net-next] net: skb: prevent the split of
 kfree_skb_reason() by gcc
To:     menglong8.dong@gmail.com
Cc:     kuba@kernel.org, ojeda@kernel.org, ndesaulniers@google.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        asml.silence@gmail.com, imagedong@tencent.com,
        luiz.von.dentz@intel.com, vasily.averin@linux.dev,
        jk@codeconstruct.com.au, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 11, 2022 at 2:07 PM <menglong8.dong@gmail.com> wrote:
>
> diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
> index 445e80517cab..51f7c13bca98 100644
> --- a/include/linux/compiler_attributes.h
> +++ b/include/linux/compiler_attributes.h
> @@ -371,4 +371,6 @@
>   */
>  #define __weak                          __attribute__((__weak__))
>
> +#define __nofnsplit                     __attribute__((optimize("O1")))
> +
>  #endif /* __LINUX_COMPILER_ATTRIBUTES_H */

Two notes on this: please use the double underscore form:
`__optimize__` and keep the file sorted (it should go after
`__overloadable__`, since we sort by the actual attribute name).

Thanks!

Cheers,
Miguel
