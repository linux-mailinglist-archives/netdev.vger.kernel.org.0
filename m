Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAB534F6651
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238428AbiDFRE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238469AbiDFREM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:04:12 -0400
X-Greylist: delayed 340 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 06 Apr 2022 07:49:01 PDT
Received: from ustc.edu.cn (email6.ustc.edu.cn [IPv6:2001:da8:d800::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BFC0447584B;
        Wed,  6 Apr 2022 07:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mail.ustc.edu.cn; s=dkim; h=Received:Date:From:To:Subject:
        Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID;
        bh=0sTHv7VvDW8oTRBOt7TYuMhuoXUUhBY50zm+RywcRJE=; b=b9h3PyVixUBqF
        KdSzg25xtAg1bM9do59cLls0FxVNtMiuN5dE00nOczYsctJePDcLnlWePt3TUml0
        lkXHk9TmEdJ0gEVhv89R6YHC9B9MVjpEO3gXiby3n8aOBkusTPiiYIm9GlxOmTTK
        t8KSj+6s834UqP1X8xhiBkRla6El1U=
Received: by ajax-webmail-newmailweb.ustc.edu.cn (Coremail) ; Wed, 6 Apr
 2022 22:43:20 +0800 (GMT+08:00)
X-Originating-IP: [222.64.172.188]
Date:   Wed, 6 Apr 2022 22:43:20 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   wuzongyo@mail.ustc.edu.cn
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [Question] Failed to load ebpf program with BTF-defined map
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT3.0.8 dev build
 20210401(c5ff3689) Copyright (c) 2002-2022 www.mailtech.cn ustccn
X-SendMailWithSms: false
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <12b95db5.295d.17fff547855.Coremail.wuzongyo@mail.ustc.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: LkAmygAXHtYIp01iy+ADAA--.0W
X-CM-SenderInfo: pzx200xj1rqzxdloh3xvwfhvlgxou0/1tbiAQwICVQhoFZrBAABsh
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I wrote a simple tc-bpf program like that:

    #include <linux/bpf.h>
    #include <linux/pkt_cls.h>
    #include <linx/types.h>
    #include <bpf/bpf_helpers.h>

    struct {
        __uint(type, BPF_MAP_TYPE_HASH);
        __uint(max_entries, 1);
        __type(key, int);
        __type(value, int);
    } hmap SEC(".maps");

    SEC("classifier")
    int _classifier(struct __sk_buff *skb)
    {
        int key = 0;
        int *val;

        val = bpf_map_lookup_elem(&hmap, &key);
        if (!val)
            return TC_ACT_OK;
        return TC_ACT_OK;
    }

    char __license[] SEC("license") = "GPL";

Then I tried to use tc to load the program:
    
    tc qdisc add dev eth0 clsact
    tc filter add dev eth0 egress bpf da obj test_bpf.o

But the program loading failed with error messages:

    Prog section 'classifier' rejected: Permission denied (13)!
    - Type:          3
    - Instructions:  9 (0 over limit
    - License:       GPL

    Verifier analysis:

    Error fetching program/map!
    Unable to load program

I tried to replace the map definition with the following code and the program is loaded successfully!

    struct bpf_map_def SEC("maps") hmap = {
        .type = BPF_MAP_TYPE_HASH,
        .key_size = sizeof(int),
        .value_size = sizeof(int),
        .max_entries = 1,
    };

With bpftrace, I can find that the errno -EACCES is returned by function do_check(). But I am still confused what's wrong with it.

Linux Version: 5.17.0-rc3+ with CONFIG_DEBUG_INFO_BTF=y
TC Version: 5.14.0

Any suggestion will be appreciated!

Thanks
