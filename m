Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA41D4DCAE1
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 17:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236365AbiCQQM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 12:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236367AbiCQQM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 12:12:58 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0072214F96
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 09:11:40 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id o6-20020a17090a9f8600b001c6562049d9so5894658pjp.3
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 09:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=wywg4x91ht1wDsZE8LDgwKs/937jDdBiI3aoJq8Icig=;
        b=EcRFu47wdTKbqMSAq17bN6l3fW68je9I7sz6dNGS5tKD2WRbtx22XzizUZtR0qkyAQ
         QWP1OHwCDN5A0Nw0t3Q7qmd76Q7jNga+edrTyslT2xibkPds1nD37wWbuAnO8SwFuhrO
         gsVcYZtwJfnoFR7QpeZ53g8ha9BP7vQeAQagIeRfmuB8NZSh871Oy/O22T8GKZQsso7+
         GAqKZ5LuYXbJaI8VOrspWlTrq9NYT2zp8TS48/UvpIibmW0S8anvsp+TLqAO1q5KW6Bh
         lxRLQvTEz/3EMFmPsbBbDBLIo1E7GTCaZssTwBenfG227MP1XIuXr1IbCZbQ1ApUnFqh
         aueg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=wywg4x91ht1wDsZE8LDgwKs/937jDdBiI3aoJq8Icig=;
        b=O81ehx4NZafhFnKswSq9jTF1Ow5AN+G2M2iNPrH7Jg9BsbDVrXslF2gSIKxNDbBeWL
         Z6nF+R+J9VNrxyMk7nn50Sf851JHkPiAj1QfujcFsNdhl5odoh8JI1Qjnq0hHAjOVJDw
         kl55Fze4N/2CbVhEfAXQrkwILYgZNzfAcZ6hynvOgkihyR4q/dJinREfRE0RWl9rTkjX
         3oyMp89pR5+FtCfGihjcJETc8iRAwA7c0SwN4J8arN7HFfvWAZfPTDoqKQHouTTq1nJa
         QNE5CcmhFcxtfP/4yPwBoJBI/FRVYWPmJWzGs+/bmTh+f6/9tR4UxqOGoOki5Hfyo6iy
         7oCw==
X-Gm-Message-State: AOAM5304prCiXkhvsNFIMhXFaNOpVznfm/G3FOjNAYVnjUggVKfWdwvQ
        9+27ScQv6j5YpajmtLZ++ZKfiA==
X-Google-Smtp-Source: ABdhPJzujChC6izQDJEHNAPYk2A2y6Fs/ty0Hxcz37xAtsWb7B2FaolAnh/R0gH50blU6B7YVSPE4w==
X-Received: by 2002:a17:902:7613:b0:151:6e1c:c49c with SMTP id k19-20020a170902761300b001516e1cc49cmr5906213pll.109.1647533499805;
        Thu, 17 Mar 2022 09:11:39 -0700 (PDT)
Received: from [127.0.1.1] ([2620:10d:c090:400::5:d2fd])
        by smtp.gmail.com with ESMTPSA id q10-20020a056a00088a00b004f7ceff389esm7702590pfj.152.2022.03.17.09.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 09:11:39 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Igor Kotrasinski <i.kotrasinsk@samsung.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Karol Herbst <karolherbst@gmail.com>,
        Eli Cohen <eli@mellanox.com>,
        Pekka Paalanen <ppaalanen@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>, x86@kernel.org,
        netfilter-devel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Shuah Khan <shuah@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Amit Shah <amit@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Lutomirski <luto@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-block@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        linux-usb@vger.kernel.org, coreteam@netfilter.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        nouveau@lists.freedesktop.org, Jason Wang <jasowang@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        virtualization@lists.linux-foundation.org,
        Leon Romanovsky <leon@kernel.org>,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        linux-rdma@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Joachim Fritschi <jfritschi@freenet.de>
In-Reply-To: <20220316192010.19001-1-rdunlap@infradead.org>
References: <20220316192010.19001-1-rdunlap@infradead.org>
Subject: Re: (subset) [PATCH 0/9] treewide: eliminate anonymous module_init & module_exit
Message-Id: <164753349550.89091.10994175450707575992.b4-ty@kernel.dk>
Date:   Thu, 17 Mar 2022 10:11:35 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Mar 2022 12:20:01 -0700, Randy Dunlap wrote:
> There are a number of drivers that use "module_init(init)" and
> "module_exit(exit)", which are anonymous names and can lead to
> confusion or ambiguity when reading System.map, crashes/oops/bugs,
> or an initcall_debug log.
> 
> Give each of these init and exit functions unique driver-specific
> names to eliminate the anonymous names.
> 
> [...]

Applied, thanks!

[1/9] virtio_blk: eliminate anonymous module_init & module_exit
      commit: bcfe9b6cbb4438b8c1cc4bd475221652c8f9301b

Best regards,
-- 
Jens Axboe


