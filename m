Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 915AE6D3C89
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 06:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbjDCEmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 00:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjDCEmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 00:42:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA58C143
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 21:41:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2CD0B81113
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 04:41:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1596C433D2;
        Mon,  3 Apr 2023 04:41:51 +0000 (UTC)
Content-Type: multipart/mixed; boundary="------------cTrP0mV1Y0cheX90DMlqiesC"
Message-ID: <6a1f2f8b-003e-38f3-bd7f-75eeb0520740@linux-m68k.org>
Date:   Mon, 3 Apr 2023 14:41:46 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Greg Ungerer <gerg@linux-m68k.org>
Subject: Re: net: fec: Separate C22 and C45 transactions
X-Spam-Status: No, score=-4.8 required=5.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------cTrP0mV1Y0cheX90DMlqiesC
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Andrew,

On Mon, Jan 9, at 16:30 Andrew Lunn wrote:
> net: fec: Separate C22 and C45 transactions
>     
> The fec MDIO bus driver can perform both C22 and C45 transfers.
> Create separate functions for each and register the C45 versions using
> the new API calls where appropriate.

Are you sure that all FEC hardware blocks MDIO bus units support C45
transactions?

I ask because none of the ColdFire SoC parts with the FEC block mention
supporting C45 transactions. They quote those OP bits in the MMFR register
as generating "non-compliant" MII frames - for whatever that is supposed
to mean. They are not described any further. And it looks like some of
the older iMX parts have similar wording (at least I see it in the iMX25RM
and iMX50RM). No mention of supporting C45 transactions, and that is spelt out
explicitly in various iMX6, iMX8, and other Reference Manuals.

The MMFR register bits have some variation of this for ColdFire SoCs:

     29–28      OP Operation code.
       OP       00 Write frame operation, but not MII compliant.
                01 Write frame operation for a valid MII management frame.
                10 Read frame operation for a valid MII management frame.
                11 Read frame operation, but not MII compliant.

It is fairly easy to quirk this out and only register the C45 MDIO methods
if we know they are supported. Attached patch for example.

Regards
Greg



>     Signed-off-by: Andrew Lunn <andrew@lunn.ch>
>     Signed-off-by: Michael Walle <michael@walle.cc>
>     Reviewed-by: Wei Fang <wei.fang@nxp.com>
>     Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index 644f3c963730..e6238e53940d 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -1987,47 +1987,74 @@ static int fec_enet_mdio_wait(struct fec_enet_private *fep)
>  	return ret;
>  }
>  
> -static int fec_enet_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
> +static int fec_enet_mdio_read_c22(struct mii_bus *bus, int mii_id, int regnum)
>  {
>  	struct fec_enet_private *fep = bus->priv;
>  	struct device *dev = &fep->pdev->dev;
>  	int ret = 0, frame_start, frame_addr, frame_op;
> -	bool is_c45 = !!(regnum & MII_ADDR_C45);
>  
>  	ret = pm_runtime_resume_and_get(dev);
>  	if (ret < 0)
>  		return ret;
>  
...

--------------cTrP0mV1Y0cheX90DMlqiesC
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-net-fec-make-use-of-MDIO-C45-a-quirk.patch"
Content-Disposition: attachment;
 filename="0001-net-fec-make-use-of-MDIO-C45-a-quirk.patch"
Content-Transfer-Encoding: base64

RnJvbSBjNGEyYzVmYWYwODU5M2QwYTNlMTRmZWZlOTk2MjE4ZGYxMWQyYzAxIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBHcmVnIFVuZ2VyZXIgPGdlcmdAbGludXgtbTY4ay5v
cmc+CkRhdGU6IE1vbiwgMyBBcHIgMjAyMyAxMzozNjoyNyArMTAwMApTdWJqZWN0OiBbUEFU
Q0hdIG5ldDogZmVjOiBtYWtlIHVzZSBvZiBNRElPIEM0NSBhIHF1aXJrCgpOb3QgYWxsIGZl
YyBNRElPIGJ1cyBkcml2ZXJzIHN1cHBvcnQgQzQ1IG1vZGUuIFRoZSBvbGRlciBmZWMgaGFy
ZHdhcmUKYmxvY2sgaW4gbWFueSBDb2xkRmlyZSBTb0NzIGRvIG5vdCBhcHBlYXIgdG8gc3Vw
cG9ydCB0aGlzLCBhdCBsZWFzdAphY2NvcmRpbmcgdG8gbW9zdCBvZiB0aGUgZGlmZmVyZW50
IENvbGRGaXJlIFNvQyByZWZlcmVuY2UgbWFudWFscy4KVGhlIGJpdHMgdXNlZCB0byBnZW5l
cmF0ZSBDNDUgYWNjZXNzIG9uIHRoZSBpTVggcGFydHMsIGluIHRoZSBPUCBmaWVsZApvZiB0
aGUgTU1GUiByZWdpc3RlciwgYXJlIGRvY3VtZW50ZWQgYXMgZ2VuZXJhdGluZyBub24tY29t
cGxpYW50IE1JSQpmcmFtZXMgKGl0IGlzIG5vdCBkb2N1bWVudGVkIGFzIHRvIGV4YWN0bHkg
aG93IHRoZXkgYXJlIG5vbi1jb21wbGlhbnQpLgoKQ29tbWl0IDhkMDNhZDFhYjBiMCAoIm5l
dDogZmVjOiBTZXBhcmF0ZSBDMjIgYW5kIEM0NSB0cmFuc2FjdGlvbnMiKQptZWFucyB0aGUg
ZmVjIGRyaXZlciB3aWxsIGFsd2F5cyByZWdpc3RlciBjNDUgTURJTyByZWFkIGFuZCB3cml0
ZQptZXRob2RzLiBEdXJpbmcgcHJvYmUgdGhlc2Ugd2lsbCBhbHdheXMgYmUgYWNjZXNzZWQg
Z2VuZXJhdGluZwpub24tY29tcGxhbnQgTUlJIGFjY2Vzc2VzIG9uIENvbGRGaXJlIGJhc2Vk
IGRldmljZXMuCgpBZGQgYSBxdWlyayBkZWZpbmUsIEZFQ19RVUlSS19IQVNfTURJT19DNDUs
IHRoYXQgY2FuIGJlIHVzZWQgdG8KZGlzdGluZ3Vpc2ggc2lsaWNvbiB0aGF0IHN1cHBvcnRz
IE1ESU8gQzQ1IGZyYW1pbmcgb3Igbm90LiBBZGQgdGhpcyB0bwphbGwgdGhlIGV4aXN0aW5n
IGlNWCBxdWlya3MsIHNvIHRoZXkgd2lsbCBiZSBiZWhhdmUgYXMgdGhleSBkbyBub3cgKCop
LgoKKCopIGl0IHNlZW1zIHRoYXQgc29tZSBpTVggcGFydHMgbWF5IG5vdCBzdXBwb3J0IEM0
NSBmcmFtaW5nIGVpdGhlci4KICAgIFRoZSBpTVgyNSBhbmQgaU1YNTAgUmVmZXJlbmNlIE1h
bnVhbHMgY29udGFpbnMgc2ltaWxhciB3b3JkaW5nIHRvCiAgICB0aGUgQ29sZEZpcmUgUmVm
ZXJlbmNlIE1hbnVhbHMgb24gdGhpcy4KCkZpeGVzOiA4ZDAzYWQxYWIwYjAgKCJuZXQ6IGZl
YzogU2VwYXJhdGUgQzIyIGFuZCBDNDUgdHJhbnNhY3Rpb25zIikKU2lnbmVkLW9mZi1ieTog
R3JlZyBVbmdlcmVyIDxnZXJnQGxpbnV4LW02OGsub3JnPgotLS0KIGRyaXZlcnMvbmV0L2V0
aGVybmV0L2ZyZWVzY2FsZS9mZWMuaCAgICAgIHwgIDUgKysrKwogZHJpdmVycy9uZXQvZXRo
ZXJuZXQvZnJlZXNjYWxlL2ZlY19tYWluLmMgfCAzMiArKysrKysrKysrKysrKy0tLS0tLS0t
LQogMiBmaWxlcyBjaGFuZ2VkLCAyNSBpbnNlcnRpb25zKCspLCAxMiBkZWxldGlvbnMoLSkK
CmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjLmggYi9k
cml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjLmgKaW5kZXggNWJhMWUwZDcxYzY4
Li45OTM5Y2NhZmI1NTYgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVz
Y2FsZS9mZWMuaAorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjLmgK
QEAgLTUwNyw2ICs1MDcsMTEgQEAgc3RydWN0IGJ1ZmRlc2NfZXggewogLyogaS5NWDZRIGFk
ZHMgcG1fcW9zIHN1cHBvcnQgKi8KICNkZWZpbmUgRkVDX1FVSVJLX0hBU19QTVFPUwkJCUJJ
VCgyMykKIAorLyogTm90IGFsbCBGRUMgaGFyZHdhcmUgYmxvY2sgTURJT3Mgc3VwcG9ydCBh
Y2Nlc3NlcyBpbiBDNDUgbW9kZS4KKyAqIE9sZGVyIGJsb2NrcyBpbiB0aGUgQ29sZEZpcmUg
cGFydHMgZG8gbm90IHN1cHBvcnQgaXQuCisgKi8KKyNkZWZpbmUgRkVDX1FVSVJLX0hBU19N
RElPX0M0NQkJQklUKDI0KQorCiBzdHJ1Y3QgYnVmZGVzY19wcm9wIHsKIAlpbnQgcWlkOwog
CS8qIEFkZHJlc3Mgb2YgUnggYW5kIFR4IGJ1ZmZlcnMgKi8KZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9mZWNfbWFpbi5jIGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvZnJlZXNjYWxlL2ZlY19tYWluLmMKaW5kZXggZjNiMTZhNjY3M2UyLi4xNjBjMWIz
NTI1ZjUgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9mZWNf
bWFpbi5jCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9mZWNfbWFpbi5j
CkBAIC0xMDAsMTggKzEwMCwxOSBAQCBzdHJ1Y3QgZmVjX2RldmluZm8gewogCiBzdGF0aWMg
Y29uc3Qgc3RydWN0IGZlY19kZXZpbmZvIGZlY19pbXgyNV9pbmZvID0gewogCS5xdWlya3Mg
PSBGRUNfUVVJUktfVVNFX0dBU0tFVCB8IEZFQ19RVUlSS19NSUJfQ0xFQVIgfAotCQkgIEZF
Q19RVUlSS19IQVNfRlJSRUcsCisJCSAgRkVDX1FVSVJLX0hBU19GUlJFRyB8IEZFQ19RVUlS
S19IQVNfTURJT19DNDUsCiB9OwogCiBzdGF0aWMgY29uc3Qgc3RydWN0IGZlY19kZXZpbmZv
IGZlY19pbXgyN19pbmZvID0gewotCS5xdWlya3MgPSBGRUNfUVVJUktfTUlCX0NMRUFSIHwg
RkVDX1FVSVJLX0hBU19GUlJFRywKKwkucXVpcmtzID0gRkVDX1FVSVJLX01JQl9DTEVBUiB8
IEZFQ19RVUlSS19IQVNfRlJSRUcgfAorCQkgIEZFQ19RVUlSS19IQVNfTURJT19DNDUsCiB9
OwogCiBzdGF0aWMgY29uc3Qgc3RydWN0IGZlY19kZXZpbmZvIGZlY19pbXgyOF9pbmZvID0g
ewogCS5xdWlya3MgPSBGRUNfUVVJUktfRU5FVF9NQUMgfCBGRUNfUVVJUktfU1dBUF9GUkFN
RSB8CiAJCSAgRkVDX1FVSVJLX1NJTkdMRV9NRElPIHwgRkVDX1FVSVJLX0hBU19SQUNDIHwK
IAkJICBGRUNfUVVJUktfSEFTX0ZSUkVHIHwgRkVDX1FVSVJLX0NMRUFSX1NFVFVQX01JSSB8
Ci0JCSAgRkVDX1FVSVJLX05PX0hBUkRfUkVTRVQsCisJCSAgRkVDX1FVSVJLX05PX0hBUkRf
UkVTRVQgfCBGRUNfUVVJUktfSEFTX01ESU9fQzQ1LAogfTsKIAogc3RhdGljIGNvbnN0IHN0
cnVjdCBmZWNfZGV2aW5mbyBmZWNfaW14NnFfaW5mbyA9IHsKQEAgLTExOSwxMSArMTIwLDEy
IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgZmVjX2RldmluZm8gZmVjX2lteDZxX2luZm8gPSB7
CiAJCSAgRkVDX1FVSVJLX0hBU19CVUZERVNDX0VYIHwgRkVDX1FVSVJLX0hBU19DU1VNIHwK
IAkJICBGRUNfUVVJUktfSEFTX1ZMQU4gfCBGRUNfUVVJUktfRVJSMDA2MzU4IHwKIAkJICBG
RUNfUVVJUktfSEFTX1JBQ0MgfCBGRUNfUVVJUktfQ0xFQVJfU0VUVVBfTUlJIHwKLQkJICBG
RUNfUVVJUktfSEFTX1BNUU9TLAorCQkgIEZFQ19RVUlSS19IQVNfUE1RT1MgfCBGRUNfUVVJ
UktfSEFTX01ESU9fQzQ1LAogfTsKIAogc3RhdGljIGNvbnN0IHN0cnVjdCBmZWNfZGV2aW5m
byBmZWNfbXZmNjAwX2luZm8gPSB7Ci0JLnF1aXJrcyA9IEZFQ19RVUlSS19FTkVUX01BQyB8
IEZFQ19RVUlSS19IQVNfUkFDQywKKwkucXVpcmtzID0gRkVDX1FVSVJLX0VORVRfTUFDIHwg
RkVDX1FVSVJLX0hBU19SQUNDIHwKKwkJICBGRUNfUVVJUktfSEFTX01ESU9fQzQ1LAogfTsK
IAogc3RhdGljIGNvbnN0IHN0cnVjdCBmZWNfZGV2aW5mbyBmZWNfaW14NnhfaW5mbyA9IHsK
QEAgLTEzMiw3ICsxMzQsOCBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IGZlY19kZXZpbmZvIGZl
Y19pbXg2eF9pbmZvID0gewogCQkgIEZFQ19RVUlSS19IQVNfVkxBTiB8IEZFQ19RVUlSS19I
QVNfQVZCIHwKIAkJICBGRUNfUVVJUktfRVJSMDA3ODg1IHwgRkVDX1FVSVJLX0JVR19DQVBU
VVJFIHwKIAkJICBGRUNfUVVJUktfSEFTX1JBQ0MgfCBGRUNfUVVJUktfSEFTX0NPQUxFU0NF
IHwKLQkJICBGRUNfUVVJUktfQ0xFQVJfU0VUVVBfTUlJIHwgRkVDX1FVSVJLX0hBU19NVUxU
SV9RVUVVRVMsCisJCSAgRkVDX1FVSVJLX0NMRUFSX1NFVFVQX01JSSB8IEZFQ19RVUlSS19I
QVNfTVVMVElfUVVFVUVTIHwKKwkJICBGRUNfUVVJUktfSEFTX01ESU9fQzQ1LAogfTsKIAog
c3RhdGljIGNvbnN0IHN0cnVjdCBmZWNfZGV2aW5mbyBmZWNfaW14NnVsX2luZm8gPSB7CkBA
IC0xNDAsNyArMTQzLDggQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBmZWNfZGV2aW5mbyBmZWNf
aW14NnVsX2luZm8gPSB7CiAJCSAgRkVDX1FVSVJLX0hBU19CVUZERVNDX0VYIHwgRkVDX1FV
SVJLX0hBU19DU1VNIHwKIAkJICBGRUNfUVVJUktfSEFTX1ZMQU4gfCBGRUNfUVVJUktfRVJS
MDA3ODg1IHwKIAkJICBGRUNfUVVJUktfQlVHX0NBUFRVUkUgfCBGRUNfUVVJUktfSEFTX1JB
Q0MgfAotCQkgIEZFQ19RVUlSS19IQVNfQ09BTEVTQ0UgfCBGRUNfUVVJUktfQ0xFQVJfU0VU
VVBfTUlJLAorCQkgIEZFQ19RVUlSS19IQVNfQ09BTEVTQ0UgfCBGRUNfUVVJUktfQ0xFQVJf
U0VUVVBfTUlJIHwKKwkJICBGRUNfUVVJUktfSEFTX01ESU9fQzQ1LAogfTsKIAogc3RhdGlj
IGNvbnN0IHN0cnVjdCBmZWNfZGV2aW5mbyBmZWNfaW14OG1xX2luZm8gPSB7CkBAIC0xNTAs
NyArMTU0LDggQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBmZWNfZGV2aW5mbyBmZWNfaW14OG1x
X2luZm8gPSB7CiAJCSAgRkVDX1FVSVJLX0VSUjAwNzg4NSB8IEZFQ19RVUlSS19CVUdfQ0FQ
VFVSRSB8CiAJCSAgRkVDX1FVSVJLX0hBU19SQUNDIHwgRkVDX1FVSVJLX0hBU19DT0FMRVND
RSB8CiAJCSAgRkVDX1FVSVJLX0NMRUFSX1NFVFVQX01JSSB8IEZFQ19RVUlSS19IQVNfTVVM
VElfUVVFVUVTIHwKLQkJICBGRUNfUVVJUktfSEFTX0VFRSB8IEZFQ19RVUlSS19XQUtFVVBf
RlJPTV9JTlQyLAorCQkgIEZFQ19RVUlSS19IQVNfRUVFIHwgRkVDX1FVSVJLX1dBS0VVUF9G
Uk9NX0lOVDIgfAorCQkgIEZFQ19RVUlSS19IQVNfTURJT19DNDUsCiB9OwogCiBzdGF0aWMg
Y29uc3Qgc3RydWN0IGZlY19kZXZpbmZvIGZlY19pbXg4cW1faW5mbyA9IHsKQEAgLTE2MCwx
NCArMTY1LDE1IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgZmVjX2RldmluZm8gZmVjX2lteDhx
bV9pbmZvID0gewogCQkgIEZFQ19RVUlSS19FUlIwMDc4ODUgfCBGRUNfUVVJUktfQlVHX0NB
UFRVUkUgfAogCQkgIEZFQ19RVUlSS19IQVNfUkFDQyB8IEZFQ19RVUlSS19IQVNfQ09BTEVT
Q0UgfAogCQkgIEZFQ19RVUlSS19DTEVBUl9TRVRVUF9NSUkgfCBGRUNfUVVJUktfSEFTX01V
TFRJX1FVRVVFUyB8Ci0JCSAgRkVDX1FVSVJLX0RFTEFZRURfQ0xLU19TVVBQT1JULAorCQkg
IEZFQ19RVUlSS19ERUxBWUVEX0NMS1NfU1VQUE9SVCB8IEZFQ19RVUlSS19IQVNfTURJT19D
NDUsCiB9OwogCiBzdGF0aWMgY29uc3Qgc3RydWN0IGZlY19kZXZpbmZvIGZlY19zMzJ2MjM0
X2luZm8gPSB7CiAJLnF1aXJrcyA9IEZFQ19RVUlSS19FTkVUX01BQyB8IEZFQ19RVUlSS19I
QVNfR0JJVCB8CiAJCSAgRkVDX1FVSVJLX0hBU19CVUZERVNDX0VYIHwgRkVDX1FVSVJLX0hB
U19DU1VNIHwKIAkJICBGRUNfUVVJUktfSEFTX1ZMQU4gfCBGRUNfUVVJUktfSEFTX0FWQiB8
Ci0JCSAgRkVDX1FVSVJLX0VSUjAwNzg4NSB8IEZFQ19RVUlSS19CVUdfQ0FQVFVSRSwKKwkJ
ICBGRUNfUVVJUktfRVJSMDA3ODg1IHwgRkVDX1FVSVJLX0JVR19DQVBUVVJFIHwKKwkJICBG
RUNfUVVJUktfSEFTX01ESU9fQzQ1LAogfTsKIAogc3RhdGljIHN0cnVjdCBwbGF0Zm9ybV9k
ZXZpY2VfaWQgZmVjX2RldnR5cGVbXSA9IHsKQEAgLTI0MzQsOCArMjQ0MCwxMCBAQCBzdGF0
aWMgaW50IGZlY19lbmV0X21paV9pbml0KHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYp
CiAJZmVwLT5taWlfYnVzLT5uYW1lID0gImZlY19lbmV0X21paV9idXMiOwogCWZlcC0+bWlp
X2J1cy0+cmVhZCA9IGZlY19lbmV0X21kaW9fcmVhZF9jMjI7CiAJZmVwLT5taWlfYnVzLT53
cml0ZSA9IGZlY19lbmV0X21kaW9fd3JpdGVfYzIyOwotCWZlcC0+bWlpX2J1cy0+cmVhZF9j
NDUgPSBmZWNfZW5ldF9tZGlvX3JlYWRfYzQ1OwotCWZlcC0+bWlpX2J1cy0+d3JpdGVfYzQ1
ID0gZmVjX2VuZXRfbWRpb193cml0ZV9jNDU7CisJaWYgKGZlcC0+cXVpcmtzICYgRkVDX1FV
SVJLX0hBU19NRElPX0M0NSkgeworCQlmZXAtPm1paV9idXMtPnJlYWRfYzQ1ID0gZmVjX2Vu
ZXRfbWRpb19yZWFkX2M0NTsKKwkJZmVwLT5taWlfYnVzLT53cml0ZV9jNDUgPSBmZWNfZW5l
dF9tZGlvX3dyaXRlX2M0NTsKKwl9CiAJc25wcmludGYoZmVwLT5taWlfYnVzLT5pZCwgTUlJ
X0JVU19JRF9TSVpFLCAiJXMtJXgiLAogCQlwZGV2LT5uYW1lLCBmZXAtPmRldl9pZCArIDEp
OwogCWZlcC0+bWlpX2J1cy0+cHJpdiA9IGZlcDsKLS0gCjIuMjUuMQoK

--------------cTrP0mV1Y0cheX90DMlqiesC--
