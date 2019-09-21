Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48162B9DE9
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 14:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437860AbfIUMyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Sep 2019 08:54:45 -0400
Received: from canardo.mork.no ([148.122.252.1]:47531 "EHLO canardo.mork.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407592AbfIUMyp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Sep 2019 08:54:45 -0400
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id x8LCs4Oq011648
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Sat, 21 Sep 2019 14:54:04 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1569070444; bh=476RrLgPEJ8NLaYO7FvZFBevWqPXPGFp06PBD08o2qo=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=i1uWMpe61RewpJQRmnxLYlDgjvkuAtQVlV2PE4fsvq6TdGdhaB9ZMagkMiqFzNuom
         nVHWb1mgobZ2o01EiSwLn3n7LVxh0fLjo7NKXl4AxBNqDvmT+h/+WKknVA2J0IKpCw
         WAFiGNqwahFzupn36TUj+9ZFUW25lPX81qk8CaCY=
Received: from bjorn by miraculix.mork.no with local (Exim 4.92)
        (envelope-from <bjorn@mork.no>)
        id 1iBeto-0000tG-0x; Sat, 21 Sep 2019 14:54:04 +0200
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH net,stable] usbnet: ignore endpoints with invalid wMaxPacketSize
Organization: m
References: <20190918121738.6343-1-bjorn@mork.no>
        <20190920190303.149da58a@cakuba.netronome.com>
Date:   Sat, 21 Sep 2019 14:54:03 +0200
In-Reply-To: <20190920190303.149da58a@cakuba.netronome.com> (Jakub Kicinski's
        message of "Fri, 20 Sep 2019 19:03:03 -0700")
Message-ID: <87h855g68k.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.101.4 at canardo
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <jakub.kicinski@netronome.com> writes:

> On Wed, 18 Sep 2019 14:17:38 +0200, Bj=C3=B8rn Mork wrote:
>> Endpoints with zero wMaxPacketSize are not usable for transferring
>> data. Ignore such endpoints when looking for valid in, out and
>> status pipes, to make the drivers more robust against invalid and
>> meaningless descriptors.
>>=20
>> The wMaxPacketSize of these endpoints are used for memory allocations
>> and as divisors in many usbnet minidrivers. Avoiding zero is therefore
>> critical.
>>=20
>> Signed-off-by: Bj=C3=B8rn Mork <bjorn@mork.no>
>
> Fixes tag would be useful. I'm not sure how far into stable we should
> backport this.

That would be commit 1da177e4c3f4 ("Linux-2.6.12-rc2"), so I don't think
a Fixes tag is very useful...

I haven't verified how deep into the code you have been able to get with
wMaxPacketSize being zero.  But I don't think there ever has been much
protection since it's so obviously "insane".  There was no point in
protecting against this as long as we considered the USB port a security
barrier.

I see that the v2.6.12-rc2 version of drivers/usb/net/usbnet.c (sic)
already had this in it's genelink_tx_fixup():

^1da177e4c3f4 (Linus Torvalds  2005-04-16 15:20:36 -0700 1984)  // add padd=
ing byte
^1da177e4c3f4 (Linus Torvalds  2005-04-16 15:20:36 -0700 1985)  if ((skb->l=
en % dev->maxpacket) =3D=3D 0)
^1da177e4c3f4 (Linus Torvalds  2005-04-16 15:20:36 -0700 1986)          skb=
_put (skb, 1);
^1da177e4c3f4 (Linus Torvalds  2005-04-16 15:20:36 -0700 1987)=20
^1da177e4c3f4 (Linus Torvalds  2005-04-16 15:20:36 -0700 1988)  return skb;
^1da177e4c3f4 (Linus Torvalds  2005-04-16 15:20:36 -0700 1989) }


And this in usbnet_start_xmit():

^1da177e4c3f4 (Linus Torvalds  2005-04-16 15:20:36 -0700 3564)  /* don't as=
sume the hardware handles USB_ZERO_PACKET
^1da177e4c3f4 (Linus Torvalds  2005-04-16 15:20:36 -0700 3565)   * NOTE:  s=
trictly conforming cdc-ether devices should expect
^1da177e4c3f4 (Linus Torvalds  2005-04-16 15:20:36 -0700 3566)   * the ZLP =
here, but ignore the one-byte packet.
^1da177e4c3f4 (Linus Torvalds  2005-04-16 15:20:36 -0700 3567)   *
^1da177e4c3f4 (Linus Torvalds  2005-04-16 15:20:36 -0700 3568)   * FIXME ze=
ro that byte, if it doesn't require a new skb.
^1da177e4c3f4 (Linus Torvalds  2005-04-16 15:20:36 -0700 3569)   */
^1da177e4c3f4 (Linus Torvalds  2005-04-16 15:20:36 -0700 3570)  if ((length=
 % dev->maxpacket) =3D=3D 0)
^1da177e4c3f4 (Linus Torvalds  2005-04-16 15:20:36 -0700 3571)          urb=
->transfer_buffer_length++;
^1da177e4c3f4 (Linus Torvalds  2005-04-16 15:20:36 -0700 3572)=20


usbnet_probe() calculated dev->maxpacket as

^1da177e4c3f4 (Linus Torvalds  2005-04-16 15:20:36 -0700 3826)  dev->maxpac=
ket =3D usb_maxpacket (dev->udev, dev->out, 1);

without any sanity checking.  And usb_maxpacket() hasn't changed much.
It was pretty much the same then as now:

^1da177e4c3f4 (Linus Torvalds 2005-04-16 15:20:36 -0700 1123) usb_maxpacket=
(struct usb_device *udev, int pipe, int is_out)
^1da177e4c3f4 (Linus Torvalds 2005-04-16 15:20:36 -0700 1124) {
^1da177e4c3f4 (Linus Torvalds 2005-04-16 15:20:36 -0700 1125)   struct usb_=
host_endpoint        *ep;
^1da177e4c3f4 (Linus Torvalds 2005-04-16 15:20:36 -0700 1126)   unsigned   =
                     epnum =3D usb_pipeendpoint(pipe);
^1da177e4c3f4 (Linus Torvalds 2005-04-16 15:20:36 -0700 1127)=20
^1da177e4c3f4 (Linus Torvalds 2005-04-16 15:20:36 -0700 1128)   if (is_out)=
 {
^1da177e4c3f4 (Linus Torvalds 2005-04-16 15:20:36 -0700 1129)           WAR=
N_ON(usb_pipein(pipe));
^1da177e4c3f4 (Linus Torvalds 2005-04-16 15:20:36 -0700 1130)           ep =
=3D udev->ep_out[epnum];
^1da177e4c3f4 (Linus Torvalds 2005-04-16 15:20:36 -0700 1131)   } else {
^1da177e4c3f4 (Linus Torvalds 2005-04-16 15:20:36 -0700 1132)           WAR=
N_ON(usb_pipeout(pipe));
^1da177e4c3f4 (Linus Torvalds 2005-04-16 15:20:36 -0700 1133)           ep =
=3D udev->ep_in[epnum];
^1da177e4c3f4 (Linus Torvalds 2005-04-16 15:20:36 -0700 1134)   }
^1da177e4c3f4 (Linus Torvalds 2005-04-16 15:20:36 -0700 1135)   if (!ep)
^1da177e4c3f4 (Linus Torvalds 2005-04-16 15:20:36 -0700 1136)           ret=
urn 0;
^1da177e4c3f4 (Linus Torvalds 2005-04-16 15:20:36 -0700 1137)=20
^1da177e4c3f4 (Linus Torvalds 2005-04-16 15:20:36 -0700 1138)   /* NOTE:  o=
nly 0x07ff bits are for packet size... */
^1da177e4c3f4 (Linus Torvalds 2005-04-16 15:20:36 -0700 1139)   return le16=
_to_cpu(ep->desc.wMaxPacketSize);
^1da177e4c3f4 (Linus Torvalds 2005-04-16 15:20:36 -0700 1140) }


So, to summarize:  I believe the fix is valid for all stable versions.

I'll leave it up to the more competent stable maintainers to decide how
many, if any, it should be backported to.  I will not cry if the answer
is none.


> Is this something that occurs on real devices or protection from
> malicious ones?

Only malicious ones AFAICS.

I don't necessarily agree, but I believe the current policy makes this a
"security" issue.  CVEs have previously been allocated for similar
crashes triggered by buggy USB descriptors.  For some reason we are
supposed to protect the system against *some* types of malicious
hardware.

I am looking forward to the fixes coming up next to protect against
malicious CPUs and microcode ;-)



Bj=C3=B8rn
