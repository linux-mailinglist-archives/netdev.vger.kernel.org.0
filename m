Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82978617B76
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 12:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbiKCLXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 07:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiKCLXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 07:23:51 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07EE910FD0;
        Thu,  3 Nov 2022 04:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=FhILi2yfvcxktek07eALVO1HW7rm9P9MDUCD3dvjgj4=; b=uEwHMbZ4rD8zck0Mz0UGcuvEQ0
        y3D4aZVJrWTJL8/ieTRoUZ4LAYaO1SXm006oXFwKxXYC7rtchdOAeT0zejdtPc3rMGT7Zxr06VhQh
        dnfHxX/4PkT5a9SykYNegtnQNMkRp5HzYq39vwkWYx9QnaTSNia7Qadskbjk3jYNwMnTjx1oi2LUD
        vJDnphR7tjTZSpyHGZUcKl4PycinJt45wGcTM3UDC+FcEtm9Cc1jj+EALteqyfKG7kjV8AjBLtziS
        wSIUcAm+dhJSAn3nA5a+ZegNJ87y9f1la1F6OMnc7wZwpSlzdhAm1V2j491M5JcqEnQFwawcZG1Xc
        gWfnG6oA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35090)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oqYJX-0006E1-8A; Thu, 03 Nov 2022 11:23:15 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oqYJR-0008Jt-0G; Thu, 03 Nov 2022 11:23:09 +0000
Date:   Thu, 3 Nov 2022 11:23:08 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Yang Jihong <yangjihong1@huawei.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, illusionist.neo@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mykolal@fb.com, shuah@kernel.org,
        benjamin.tissoires@redhat.com, memxor@gmail.com, delyank@fb.com,
        asavkov@redhat.com, bpf@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH bpf RESEND 2/4] bpf: Remove size check for sk in
 bpf_skb_is_valid_access for 32-bit architecture
Message-ID: <Y2OknBtLgqTHSrvy@shell.armlinux.org.uk>
References: <20221103092118.248600-1-yangjihong1@huawei.com>
 <20221103092118.248600-3-yangjihong1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221103092118.248600-3-yangjihong1@huawei.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 03, 2022 at 05:21:16PM +0800, Yang Jihong wrote:
> The error code -EACCES is returned when bpf prog is tested in 32-bit environment,
> This is because bpf_object__relocate modifies the instruction to change memory
> size to 4 bytes, as shown in the following messages:
> 
> libbpf: prog 'kfunc_call_test1': relo #2: matching candidate #0 <byte_off> [18342] struct __sk_buff.sk (0:30:0 @ offset 168)
> libbpf: prog 'kfunc_call_test1': relo #2: patched insn #1 (LDX/ST/STX) off 168 -> 168
> libbpf: prog 'kfunc_call_test1': relo #2: patched insn #1 (LDX/ST/STX) mem_sz 8 -> 4
> 
> As a result, the bpf_skb_is_valid_access check fails. For 32-bit architecture,
> unnecessary checks need to be deleted.

Isn't the purpose of this check to ensure that the entire pointer is
written, and BPF can't write half of it?


>  	case offsetof(struct __sk_buff, sk):
> -		if (type == BPF_WRITE || size != sizeof(__u64))
> -			return false;

Wouldn't "(size != sizeof(struct bpf_sock *) && size != sizeof(__u64))"
be more appropriate here, so 32-bit can only write the 32-bit pointer
or the full 64-bit value, and 64-bit can only write the 64-bit pointer?
Or is there a reason not to? bpf folk?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
